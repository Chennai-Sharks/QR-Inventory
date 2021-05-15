import 'package:app/providers/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/utils/utils.dart';

import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.primaryBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/inventory.png',
            height: 90,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
          ),
          Center(
            child: AutoSizeText(
              'QR Inventory',
              style: GoogleFonts.rubik(
                fontSize: 50,
                color: Utils.secondaryFontColor,
                fontWeight: FontWeight.bold,
                wordSpacing: 3,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
          ),
          Container(
            margin: const EdgeInsets.only(left: 50, right: 50),
            child: Center(
              child: AutoSizeText(
                'All in one solution for your Inventory Management',
                style: GoogleFonts.rubik(
                  fontSize: 20,
                  color: Utils.secondaryFontColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ),
          MediaQuery.of(context).viewInsets.bottom == 0
              ? SizedBox(
                  height: MediaQuery.of(context).size.width * 0.7,
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.width * 0.3,
                ),
          Container(
            //alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.75,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Utils.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                elevation: 3,
              ),
              onPressed: () async => Provider.of<AuthProvider>(context, listen: false).signIn(context),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: Image.asset(
                        'assets/images/google.png',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text(
                        ' SIGN IN WITH GOOGLE',
                        style: TextStyle(
                          fontSize: 15,
                          color: Utils.primaryFontColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}