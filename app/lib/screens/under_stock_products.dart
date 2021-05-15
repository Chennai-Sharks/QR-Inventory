import 'dart:convert';

import 'package:app/screens/see_product_screen.dart';
import 'package:app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class UnderStockProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.primaryBackground,
      appBar: AppBar(
        backgroundColor: Utils.secondaryBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Under Stock Items',
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<http.Response>(
        future: http.get(
          Uri.parse(Utils.backendUrl + '/api/understockAlert/${FirebaseAuth.instance.currentUser!.uid}'),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData && snapshot.data!.statusCode < 400) {
              print(snapshot.data!.body);
              late List data;
              if (snapshot.data!.body != 'There are no products which are understocked. Good to go!')
                data = json.decode(snapshot.data!.body);

              return snapshot.data!.body == 'There are no products which are understocked. Good to go!'
                  ? Center(
                      child: Text(
                        'There are no products which are understocked. Good to go!',
                        style: GoogleFonts.rubik(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: data
                            .map(
                              (eachProduct) => Container(
                                margin: const EdgeInsets.all(20),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SeeProductScreen([eachProduct]),
                                    ));
                                  },
                                  tileColor: Utils.secondaryBackground,
                                  title: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Name: ' + eachProduct['name'],
                                      style: GoogleFonts.rubik(
                                        fontSize: 22,
                                        color: Utils.primaryFontColor,
                                      ),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Id: ' + eachProduct['productId'].toString(),
                                        style: GoogleFonts.rubik(
                                          fontSize: 16,
                                          color: Utils.primaryFontColor,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Quantity: ' + eachProduct['quantity'].toString(),
                                        style: GoogleFonts.rubik(
                                          fontSize: 16,
                                          color: Utils.primaryFontColor,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
            } else {
              return Center(
                child: Text('NO PRODUCTS'),
              );
            }
          }
        },
      ),
    );
  }
}
