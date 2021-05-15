import 'dart:convert';

import 'package:app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class LogsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      backgroundColor: Utils.primaryBackground,
      appBar: AppBar(
        backgroundColor: Utils.secondaryBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Inventory Logs',
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<http.Response>(
        future: http.get(
          Uri.parse(Utils.backendUrl + '/api/logs/${FirebaseAuth.instance.currentUser!.uid}'),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData && snapshot.data!.statusCode < 400) {
              print(snapshot.data!.body);
              final data = json.decode(snapshot.data!.body) as List;

              return SingleChildScrollView(
                child: Column(
                  children: data
                      .map(
                        (eachLog) => Container(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            tileColor: Utils.secondaryBackground,
                            title: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Log: ' + eachLog,
                                style: GoogleFonts.rubik(
                                  fontSize: 20,
                                  color: Utils.primaryFontColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            } else {
              return Center(
                child: Text('NO LOGS AVAILABLE'),
              );
            }
          }
        },
      ),
    );
  }
}
