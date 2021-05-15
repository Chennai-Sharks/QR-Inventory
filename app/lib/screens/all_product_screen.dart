import 'dart:convert';

import 'package:app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AllProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.primaryBackground,
      appBar: AppBar(
        backgroundColor: Utils.secondaryBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Your Inventory',
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<http.Response>(
        future: http.get(
          Uri.parse(Utils.backendUrl + '/api/allProducts/${FirebaseAuth.instance.currentUser!.uid}'),
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
                child: Center(
                  child: DataTable(
                    columnSpacing: 30,
                    columns: [
                      DataColumn(
                        label: Text(
                          'Id',
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Utils.primaryFontColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Name',
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Utils.primaryFontColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Quantity',
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Utils.primaryFontColor,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Price',
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Utils.primaryFontColor,
                          ),
                        ),
                      ),
                    ],
                    rows: data
                        .map(
                          (eachProduct) => DataRow(cells: [
                            DataCell(
                              Text(
                                '${eachProduct['productId']}',
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Utils.primaryFontColor,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${eachProduct['name']}',
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Utils.primaryFontColor,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${eachProduct['quantity']}',
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Utils.primaryFontColor,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${eachProduct['price']}',
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Utils.primaryFontColor,
                                ),
                              ),
                            ),
                          ]),
                        )
                        .toList(),
                  ),
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
