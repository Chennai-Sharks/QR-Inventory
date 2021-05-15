import 'dart:convert';
import 'dart:io';

import 'package:app/providers/auth_provider.dart';
import 'package:app/providers/product_provider.dart';
import 'package:app/providers/search_provider.dart';
import 'package:app/screens/add_product_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';

import 'package:app/utils/utils.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';
// import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Utils.primaryBackground,
      appBar: AppBar(
        title: Text('QR Inventory'),
        backgroundColor: Utils.secondaryBackground,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await SearchProvider.getSearchData(name: 'apples');
                },
                child: Text('enter')),
            TypeAheadField<String>(
              itemBuilder: (context, suggestion) {
                print(suggestion);
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  tileColor: Colors.white,
                  title: Text('hello'),
                  subtitle: Text('\$${suggestion}'),
                );
              },
              onSuggestionSelected: (suggestion) {
                print(suggestion);
              },
              suggestionsCallback: (pattern) {
                return SearchProvider.getSearchData(name: pattern);
              },
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                style: GoogleFonts.titilliumWeb(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  fillColor: Utils.secondaryBackground,
                  filled: true,
                  border: InputBorder.none,
                  labelText: 'Enter Product Name or Id',
                  labelStyle: GoogleFonts.rubik(
                    fontSize: 16,
                    color: Utils.primaryFontColor,
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String cameraScanResult = await scanner.scan();
                print(cameraScanResult);
                final result = cameraScanResult.split(':');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddProductScreen(productId: result[1], productName: result[0]),
                  ),
                );
              },
              child: Text('add product'),
            ),
            ElevatedButton(
              onPressed: () async {
                String cameraScanResult = await scanner.scan();
                print(cameraScanResult);
                final result = cameraScanResult.split(':');
                final product = ProductProvider();
                await product.deleteProduct(productID: result[1]);
              },
              child: Text('delete product'),
            ),
            ElevatedButton(
              onPressed: () async {
                String cameraScanResult = await scanner.scan();
                print(cameraScanResult);
                final result = cameraScanResult.split(':');
                final product = ProductProvider();

                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  backgroundColor: Utils.secondaryBackground,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: AutoSizeText(
                                  'Product Name: ',
                                  style: GoogleFonts.rubik(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: AutoSizeText(
                                  result[0],
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
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: AutoSizeText(
                                  'Product ID: ',
                                  style: GoogleFonts.rubik(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: AutoSizeText(
                                  result[1],
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
                            height: 25,
                          ),
                          AutoSizeText(
                            'Enter Quantity of Stock In:',
                            style: GoogleFonts.rubik(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: VxStepper(
                              inputBoxColor: Utils.primaryFontColor,
                              actionButtonColor: Utils.secondaryBackground,
                              actionIconColor: Utils.primaryFontColor,
                              onChange: (value) {
                                setState(() {
                                  quantity = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                await product.stockInProduct(
                                  quantity: quantity,
                                  productId: result[1],
                                  context: context,
                                );
                                Navigator.of(context).pop();
                              },
                              child: Text('done'),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );

                // await addProduct.deleteProduct(productID: result[1]);
              },
              child: Text('stock in'),
            ),
            ElevatedButton(
              onPressed: () async {
                String cameraScanResult = await scanner.scan();
                print(cameraScanResult);
                final result = cameraScanResult.split(':');
                final product = ProductProvider();

                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  backgroundColor: Utils.secondaryBackground,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: AutoSizeText(
                                  'Product Name: ',
                                  style: GoogleFonts.rubik(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: AutoSizeText(
                                  result[0],
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
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: AutoSizeText(
                                  'Product ID: ',
                                  style: GoogleFonts.rubik(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: AutoSizeText(
                                  result[1],
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
                            height: 25,
                          ),
                          AutoSizeText(
                            'Enter Quantity of Stock Out:',
                            style: GoogleFonts.rubik(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: VxStepper(
                              inputBoxColor: Utils.primaryFontColor,
                              actionButtonColor: Utils.secondaryBackground,
                              actionIconColor: Utils.primaryFontColor,
                              onChange: (value) {
                                setState(() {
                                  quantity = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                await product.stockOutProduct(
                                  quantity: quantity,
                                  productId: result[1],
                                  context: context,
                                );
                                Navigator.of(context).pop();
                              },
                              child: Text('done'),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );

                // await addProduct.deleteProduct(productID: result[1]);
              },
              child: Text('stock out'),
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