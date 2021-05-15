import 'package:app/utils/utils.dart';

import 'package:app/providers/auth_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(
      FirebaseAuth.instance.currentUser!.photoURL!,
    );
    return Scaffold(
      backgroundColor: Utils.primaryBackground,
      appBar: AppBar(
        backgroundColor: Utils.secondaryBackground,
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Align(
              alignment: Alignment.center,
              child: Card(
                elevation: 10,
                shadowColor: Utils.secondaryBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55),
                ),
                child: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      FirebaseAuth.instance.currentUser!.photoURL!,
                      height: 90,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  radius: 45,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              // height: 20,
              color: Utils.secondaryBackground,
              endIndent: MediaQuery.of(context).size.width * 0.3,
              thickness: 4,
              indent: MediaQuery.of(context).size.width * 0.3,
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder<String>(
              future: Provider.of<AuthProvider>(context, listen: false).getCompanyName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                else
                  return AutoSizeText(
                    snapshot.data!,
                    style: GoogleFonts.rubik(
                      fontSize: 40,
                    ),
                    textAlign: TextAlign.center,
                  );
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: AutoSizeText(
                    'User Name:',
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: AutoSizeText(
                    FirebaseAuth.instance.currentUser!.displayName!,
                    style: GoogleFonts.titilliumWeb(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: AutoSizeText(
                    'Phone:',
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: AutoSizeText(
                    FirebaseAuth.instance.currentUser!.phoneNumber == ''
                        ? 'Not Available'
                        : FirebaseAuth.instance.currentUser!.phoneNumber!,
                    style: GoogleFonts.titilliumWeb(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: AutoSizeText(
                    'Email:',
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: AutoSizeText(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: GoogleFonts.titilliumWeb(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Divider(
              height: 20,
              color: Utils.secondaryBackground,
              endIndent: MediaQuery.of(context).size.width * 0.3,
              thickness: 4,
              indent: MediaQuery.of(context).size.width * 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
