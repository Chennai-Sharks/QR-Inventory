import 'package:app/providers/product_provider.dart';
import 'package:app/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:velocity_x/velocity_x.dart';

class CustomFabSearch extends StatefulWidget {
  @override
  _CustomFabStateSearch createState() => _CustomFabStateSearch();
}

class _CustomFabStateSearch extends State<CustomFabSearch> {
  int quantity = 0;
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(
      key: fabKey,
      ringColor: Utils.secondaryBackground,
      fabColor: Utils.secondaryFontColor,
      fabOpenIcon: Icon(
        Icons.menu,
        color: Utils.primaryFontColor,
      ),
      fabCloseIcon: Icon(
        Icons.close,
        color: Utils.primaryFontColor,
      ),
      children: [
        TextButton(
          onPressed: () async {
            fabKey.currentState!.close();

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
                          style: ElevatedButton.styleFrom(
                            primary: Utils.secondaryGreen,
                          ),
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

            // await addProduct.deleteProduct(productID: result[1]);
          },
          style: TextButton.styleFrom(
            primary: Utils.primaryFontColor,
            minimumSize: Size(50, 30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'Stock out \nProduct',
              style: GoogleFonts.rubik(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            fabKey.currentState!.close();

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

            // await addProduct.deleteProduct(productID: result[1]);
          },
          style: TextButton.styleFrom(
            primary: Utils.primaryFontColor,
            minimumSize: Size(20, 30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'Stock In \nProduct',
              style: GoogleFonts.rubik(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
