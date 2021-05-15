import 'dart:convert';

import 'package:app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class ProductProvider {
  Future<void> addProduct({required Map<String, dynamic> data, required BuildContext context}) async {
    data.update('quantity', (value) => int.parse(value));

    final response = await http.post(
      Uri.parse(Utils.backendUrl + '/api/addProduct/${FirebaseAuth.instance.currentUser!.uid}'),
      headers: Utils.headerValue,
      body: json.encode(data),
    );

    if (response.statusCode >= 400) VxToast.show(context, msg: response.body);
  }

  Future<void> deleteProduct({required String productID}) async {
    final response = await http.delete(
      Uri.parse(Utils.backendUrl + '/api/deleteProduct/${FirebaseAuth.instance.currentUser!.uid}'),
      headers: Utils.headerValue,
      body: json.encode({
        'productId': productID,
      }),
    );

    print(response.body);
  }

  Future<void> stockInProduct({
    required int quantity,
    required String productId,
    required BuildContext context,
  }) async {
    final response = await http.patch(
      Uri.parse(Utils.backendUrl + '/api/stock/add/${FirebaseAuth.instance.currentUser!.uid}'),
      headers: Utils.headerValue,
      body: json.encode({
        'productId': productId,
        'value': quantity,
      }),
    );

    print(response.body);
    VxToast.show(context, msg: response.body);
  }

  Future<void> stockOutProduct({
    required int quantity,
    required String productId,
    required BuildContext context,
  }) async {
    final response = await http.patch(
      Uri.parse(Utils.backendUrl + '/api/stock/remove/${FirebaseAuth.instance.currentUser!.uid}'),
      headers: Utils.headerValue,
      body: json.encode({
        'productId': productId,
        'value': quantity,
      }),
    );

    print(response.body);
    VxToast.show(context, msg: response.body);
  }
}
