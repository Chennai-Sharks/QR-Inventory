import 'dart:convert';
import 'dart:io';

import 'package:app/providers/auth_provider.dart';
import 'package:app/providers/product_provider.dart';
import 'package:app/screens/add_product_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';

import 'package:app/utils/utils.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
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
            // TypeAheadField(
            //   itemBuilder: (context, suggestion) {
            //     return ListTile(
            //       leading: Icon(Icons.shopping_cart),
            //       title: Text('hello'),
            //       subtitle: Text('\$${'hello'}'),
            //     );
            //   },
            //   textFieldConfiguration: TextFieldConfiguration(
            //     autofocus: false,
            //     style: GoogleFonts.titilliumWeb(
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //     ),
            //     decoration: InputDecoration(
            //       fillColor: Utils.secondaryBackground,
            //       filled: true,
            //       border: InputBorder.none,
            //       focusedBorder: InputBorder.none,
            //       enabledBorder: InputBorder.none,
            //       errorBorder: InputBorder.none,
            //       disabledBorder: InputBorder.none,
            //     ),
            //   ),
            //   itemBuilder: (BuildContext context, itemData) {},
            // ),

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
                final addProduct = ProductProvider();
                await addProduct.deleteProduct(productID: result[1]);
              },
              child: Text('delete product'),
            ),
            ElevatedButton(
              onPressed: () async {
                String cameraScanResult = await scanner.scan();
                print(cameraScanResult);
                final result = cameraScanResult.split(':');
                final addProduct = ProductProvider();
                await addProduct.deleteProduct(productID: result[1]);
              },
              child: Text('stock in'),
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