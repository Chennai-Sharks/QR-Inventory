import 'dart:io';

import 'package:app/providers/auth_provider.dart';
import 'package:app/providers/search_provider.dart';
import 'package:app/screens/all_product_screen.dart';
import 'package:app/screens/auth_screen.dart';
import 'package:app/screens/logs_screen.dart';
import 'package:app/screens/see_product_screen.dart';
import 'package:app/screens/under_stock_products.dart';
import 'package:app/widgets/custom_drawer.dart';
import 'package:app/widgets/custom_fab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:app/utils/utils.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int quantity = 0;

  Future<void> selectedPopUpMenu(int value, BuildContext ct) async {
    if (value == 1) {
      final close = VxToast.showLoading(context, msg: 'Saving...');

      try {
        final response = await get(Uri.parse(Utils.backendUrl + '/api/pdf/${FirebaseAuth.instance.currentUser!.uid}'));

        final output = await getExternalStorageDirectory();
        final file = File("/storage/emulated/0/Download/example.pdf");
        print(output!.path);
        await file.writeAsBytes(response.bodyBytes.buffer.asUint8List());
        close();
        VxToast.show(context, msg: 'Done');
      } catch (error) {
        print(error);
        close();
      }
    } else if (value == 2) {
      AuthProvider.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => AuthScreen(),
      ));
    } else
      showAboutDialog(
        context: ct,
        applicationName: 'QR Inventory',
        applicationVersion: '\n1.0.0',
        applicationIcon: SizedBox(
          height: 50,
          width: 50,
          child: Image.asset('assets/images/inventory.png'),
        ),
        applicationLegalese: 'Created by Chennai Sharks',
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.primaryBackground,
      drawer: CustomDrawer(),
      floatingActionButton: CustomFab(),
      appBar: AppBar(
        title: Text('QR Inventory'),
        backgroundColor: Utils.secondaryBackground,
        centerTitle: true,
        actions: [
          PopupMenuButton(
              color: Utils.secondaryBackground,
              onSelected: (value) async {
                await selectedPopUpMenu(value as int, context);
              },
              itemBuilder: (ctx) {
                return [
                  PopupMenuItem(
                    child: Text(
                      'Save Inventory Data as PDF',
                      style: GoogleFonts.rubik(
                        color: Utils.primaryFontColor,
                      ),
                    ),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Logout',
                      style: GoogleFonts.rubik(
                        color: Utils.primaryFontColor,
                      ),
                    ),
                    value: 2,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'About',
                      style: GoogleFonts.rubik(
                        color: Utils.primaryFontColor,
                      ),
                    ),
                    value: 3,
                  ),
                ];
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome to \nQR Inventory !',
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Utils.primaryFontColor,
                      ),
                    ),
                    TextSpan(
                      text:
                          '\n\n An all-purpose inventory management app for any sort of storage you have! \n\nFrom the mammoth to the micro, your deets are just a simple scan of a QR code away! \n\nAdd, update and remove info about your stocks, stored securely with the only key being your gmail account user Id. \n\nPick up your phone, scan the black-and-white bars to completely revolutionize the way you view all things inventory!',
                      style: GoogleFonts.rubik(
                        fontSize: 16,
                        color: Utils.primaryFontColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TypeAheadField(
                loadingBuilder: (context) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    height: MediaQuery.of(context).size.height * 0.2,
                    color: Utils.secondaryBackground,
                  );
                },
                itemBuilder: (context, suggestion) {
                  print(suggestion);
                  return ListTile(
                    tileColor: Utils.primaryColor,
                    title: Text(
                      '${suggestion}',
                      style: GoogleFonts.rubik(
                        fontSize: 20,
                        color: Utils.primaryFontColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) async {
                  print(suggestion);
                  final getData = await SearchProvider.getSearchFullData(name: suggestion.toString());
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SeeProductScreen(getData),
                  ));
                },
                suggestionsCallback: (pattern) {
                  return SearchProvider.getSearchData(name: pattern);
                },
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: false,
                  style: GoogleFonts.titilliumWeb(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    fillColor: Utils.secondaryBackground,
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: '   Search Product using Name or Id:',
                    labelStyle: GoogleFonts.rubik(
                      fontSize: 16,
                      color: Utils.primaryFontColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AllProductsScreen(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Utils.secondaryGreen,
                    ),
                    child: Text(
                      'All Inventory Products',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UnderStockProductScreen(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Utils.secondaryPeach,
                  ),
                  child: Text(
                    'UnderStock Products',
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LogsScreen(),
                ));
              },
              style: ElevatedButton.styleFrom(
                primary: Utils.secondaryFontColor,
              ),
              child: Text(
                'Inventory Logs',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// [Sign out code]
///
///  ElevatedButton(
//   onPressed: () {
//     authProvider.signOut();
//     Navigator.of(context).pushReplacement(MaterialPageRoute(
//       builder: (context) => AuthScreen(),
//     ));
//   },
//   child: Text(
//     'Onnum eh illaaaa, aprom vanga',
//     style: GoogleFonts.rubik(
//       fontSize: 30,
//     ),
//   ),
// ),

//    Center(
//   child: ElevatedButton(
//     onPressed: () async {
//       final response =
//           await get(Uri.parse('http://192.168.0.101:3000/api/pdf/${FirebaseAuth.instance.currentUser!.uid}'));

//       // print(response.bodyBytes);

//       final output = await getExternalStorageDirectory();
//       final file = File("/storage/emulated/0/Downloads/example.pdf");
//       print(output!.path);
//       await file.writeAsBytes(response.bodyBytes.buffer.asUint8List());
//       print('done');
//       // print(response.body);
//       // Navigator.of(context).push(MaterialPageRoute(
//       //   builder: (context) => ProfileScreen(),
//       // ));
//     },
//     child: Text(
//       'Onnum eh illaaaa, aprom vanga',
//       style: GoogleFonts.rubik(
//         fontSize: 30,
//       ),
//     ),
//   ),
// ),