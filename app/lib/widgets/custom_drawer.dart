import 'dart:js';

import 'package:app/providers/product_provider.dart';
import 'package:app/screens/add_product_screen.dart';
import 'package:app/screens/all_product_screen.dart';
import 'package:app/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:velocity_x/velocity_x.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Utils.secondaryBackground,
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Utils.primaryFontColor,
              thickness: 2,
              endIndent: 20,
              indent: 20,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AllProductsScreen(),
                ));
              },
              title: Text(
                'Your Inventory',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: CircleAvatar(
                child: Text(
                  '1',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Utils.primaryFontColor,
              ),
            ),
            Divider(
              color: Utils.primaryFontColor,
              thickness: 2,
              endIndent: 20,
              indent: 20,
            ),
            ListTile(
              onTap: () async {
                String cameraScanResult = await scanner.scan();
                print(cameraScanResult);
                final result = cameraScanResult.split(':');
                Navigator.of(context).pop();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddProductScreen(productId: result[1], productName: result[0]),
                  ),
                );
              },
              title: Text(
                'Add New Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: CircleAvatar(
                child: Text(
                  '2',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Utils.primaryFontColor,
              ),
            ),
            Divider(
              color: Utils.primaryFontColor,
              thickness: 2,
              endIndent: 20,
              indent: 20,
            ),
            ListTile(
              onTap: () async {
                String cameraScanResult = await scanner.scan();
                print(cameraScanResult);
                final result = cameraScanResult.split(':');
                final product = ProductProvider();
                await product.deleteProduct(productID: result[1], context: context);
                Navigator.of(context).pop();
              },
              title: Text(
                'Delete Existing Product',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: CircleAvatar(
                child: Text(
                  '3',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Utils.primaryFontColor,
              ),
            ),
            Divider(
              color: Utils.primaryFontColor,
              thickness: 2,
              endIndent: 20,
              indent: 20,
            ),
            ListTile(
              onTap: () async {
                String cameraScanResult = await scanner.scan();
                print(cameraScanResult);
                final result = cameraScanResult.split(':');
                final product = ProductProvider();

                await showModalBottomSheet(
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
                              style: ElevatedButton.styleFrom(
                                primary: Utils.secondaryGreen,
                              ),
                              onPressed: () async {
                                await product.stockInProduct(
                                  quantity: quantity,
                                  productId: result[1],
                                  context: context,
                                );
                                Navigator.of(context).pop();
                              },
                              child: Text('Done'),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
                Navigator.of(context).pop();
              },
              title: Text(
                'Stock In Product',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: CircleAvatar(
                child: Text(
                  '4',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Utils.primaryFontColor,
              ),
            ),
            Divider(
              color: Utils.primaryFontColor,
              thickness: 2,
              endIndent: 20,
              indent: 20,
            ),
            ListTile(
              onTap: () async {
                String cameraScanResult = await scanner.scan();
                print(cameraScanResult);
                final result = cameraScanResult.split(':');
                final product = ProductProvider();

                await showModalBottomSheet(
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
                              child: Text('Done'),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
                Navigator.of(context).pop();
              },
              title: Text(
                'Stock Out Product',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: CircleAvatar(
                child: Text(
                  '5',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Utils.primaryFontColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
