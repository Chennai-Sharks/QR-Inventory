import 'package:app/utils/utils.dart';

import 'package:app/screens/home_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart' show VxToast;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  String? companyName;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool get isAuth => companyName != null;

  Future<bool> autoLogin() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    if (!s.containsKey('companyName')) {
      return false;
    }
    companyName = s.getString('companyName');

    notifyListeners();
    return true;
  }

  Future<void> setAuthToken(String token) async {
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

    await flutterSecureStorage.write(key: 'authToken', value: token);
  }

  Future<void> setCompanyName(String name) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString('companyName', name);
    notifyListeners();
  }

  Future<String> getCompanyName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getString('companyName')!;
  }

  Future<void> signIn(BuildContext context) async {
    final closeLoading = VxToast.showLoading(context, msg: 'Signing In...');
    final TextEditingController companyNameController = TextEditingController();
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication gs = await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: gs.idToken,
          accessToken: gs.accessToken,
        );
        final userData = await _auth.signInWithCredential(credential);

        final checkResponse = await http.post(
          Uri.parse(Utils.backendUrl + '/api/oauth/checkIfUserExist'),
          headers: Utils.headerValue,
          body: json.encode({
            'googleId': userData.user!.uid,
          }),
        );
        print(checkResponse.body);

        if (checkResponse.statusCode < 400) {
          print('here');
          final checkResponseJSon = json.decode(checkResponse.body) as Map<String, dynamic>;
          await setAuthToken(checkResponseJSon['authToken']);
          await setCompanyName(checkResponseJSon['companyName']);
          notifyListeners();
          closeLoading();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
          return;
        }

        closeLoading();

        final result = await showGeneralDialog(
            barrierDismissible: true,
            barrierLabel: 'company name',
            context: context,
            pageBuilder: (ctx, _, __) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                backgroundColor: Utils.secondaryBackground,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: AutoSizeText(
                        'Enter Company Name',
                        style: GoogleFonts.rubik(
                          fontSize: 22,
                          color: Utils.primaryFontColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextField(
                        maxLines: 1,
                        controller: companyNameController,
                        style: GoogleFonts.titilliumWeb(
                          color: Utils.primaryFontColor,
                        ),
                        decoration: InputDecoration(
                          fillColor: Utils.primaryBackground,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          filled: true,
                          labelText: 'Enter:',
                          labelStyle: GoogleFonts.titilliumWeb(
                            color: Utils.primaryFontColor,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Utils.primaryFontColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Utils.primaryFontColor,
                          ),
                          onPressed: () {
                            if (companyNameController.text == '') {
                              VxToast.show(context, msg: 'Company Name cannot be Empty');
                              return;
                            }
                            Navigator.of(context).pop<String>('done');
                          },
                          child: Text('Ok'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
        if (result == null) {
          throw Exception('Error setting the company name');
        }
        print('here');

        final response = await http.post(
          Uri.parse(Utils.backendUrl + '/api/oauth'),
          headers: Utils.headerValue,
          body: json.encode({
            'googleId': userData.user!.uid,
            'name': userData.user!.displayName,
            'companyName': companyNameController.text,
            'email': userData.user!.email,
            'phone': userData.user!.phoneNumber ?? '',
          }),
        );

        print('came here');

        final responseData = json.decode(response.body) as Map<String, dynamic>;

        await setAuthToken(responseData['authToken']);
        print(responseData);
        await setCompanyName(responseData['companyName']);

        notifyListeners();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));

        //patch is for appending the data, put is for putting new data with custom name.
      }
    } catch (error) {
      print(error);
    }
  }

  static Future<void> signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();

    await FirebaseAuth.instance.signOut();
  }
}
