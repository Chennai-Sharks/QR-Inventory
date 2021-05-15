import 'package:app/utils/utils.dart';
import 'package:app/widgets/custom_fab_search.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeeProductScreen extends StatefulWidget {
  final List product;
  SeeProductScreen(this.product);
  @override
  _SeeProductScreenState createState() => _SeeProductScreenState();
}

class _SeeProductScreenState extends State<SeeProductScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.product[0]);
    return Scaffold(
      backgroundColor: Utils.primaryBackground,
      floatingActionButton: CustomFabSearch(),
      appBar: AppBar(
        backgroundColor: Utils.secondaryBackground,
        title: Text('Product Info'),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: AutoSizeText(
                    'Product Id:',
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: AutoSizeText(
                    widget.product[0]["productId"],
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
                    'Product Name:',
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: AutoSizeText(
                    widget.product[0]["name"],
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
                    'Quantity:',
                    style: GoogleFonts.rubik(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: AutoSizeText(
                    widget.product[0]["quantity"].toString(),
                    style: GoogleFonts.titilliumWeb(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
