import 'package:app/providers/product_provider.dart';
import 'package:app/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductScreen extends StatelessWidget {
  final String productName;
  final String productId;

  final _formKey = GlobalKey<FormBuilderState>();

  AddProductScreen({
    required this.productId,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.primaryBackground,
      appBar: AppBar(
        backgroundColor: Utils.secondaryBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add a New Product',
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
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
                      'Product Id: ',
                      style: GoogleFonts.rubik(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: AutoSizeText(
                      productId,
                      style: GoogleFonts.titilliumWeb(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
                      productName,
                      style: GoogleFonts.titilliumWeb(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(15),
                child: FormBuilderTextField(
                  name: 'quantity',
                  maxLines: 1,
                  style: GoogleFonts.titilliumWeb(
                    color: Utils.primaryFontColor,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.numeric(context),
                  ]),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Utils.secondaryBackground,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: true,
                    labelText: 'Enter Quantity:',
                    labelStyle: GoogleFonts.titilliumWeb(
                      color: Utils.primaryFontColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: FormBuilderTextField(
                  name: 'price',
                  maxLines: 1,
                  style: GoogleFonts.titilliumWeb(
                    color: Utils.primaryFontColor,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.numeric(context),
                  ]),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Utils.secondaryBackground,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: true,
                    labelText: 'Enter Price:',
                    labelStyle: GoogleFonts.titilliumWeb(
                      color: Utils.primaryFontColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  if (_formKey.currentState!.validate()) {
                    print(_formKey.currentState!.value);
                    final data = {..._formKey.currentState!.value};
                    data.addAll({
                      'name': productName,
                      'productId': productId,
                    });
                    final addProduct = ProductProvider();
                    addProduct.addProduct(data: data);
                  } else {
                    print("validation failed");
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
