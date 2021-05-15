import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.primaryBackground,
      appBar: AppBar(
        backgroundColor: Utils.primaryBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Welcome!!',
          style: GoogleFonts.rubik(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
