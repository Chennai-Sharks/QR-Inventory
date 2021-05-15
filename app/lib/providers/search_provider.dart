import 'dart:convert';

import 'package:app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

//
class SearchProvider {
  static Future<List> getSearchData({required String name}) async {
    final response = await http.get(
      Uri.parse(Utils.backendUrl + '/api/search/${name}'),
      headers: {
        ...Utils.headerValue,
        'id': FirebaseAuth.instance.currentUser!.uid,
      },
    );
    final responseData = json.decode(response.body);
    print(responseData);
    // var p = [{_id: 609fbff5d393bc1854edb908, inventory: [{quantity: 30, _id: 609fd8a4e3817717e403008a, productId: 123ef, price: 8000, name: apples}]}];

    final listOfProducts = responseData[0]['inventory'];

    // print(listOfProducts);

    final listOfProductsName = listOfProducts.map((eachItem) => eachItem['name']).toList();
    // print(listOfProductsName);

    return listOfProductsName;
  }

  static Future<List> getSearchFullData({required String name}) async {
    final response = await http.get(
      Uri.parse(Utils.backendUrl + '/api/search/${name}'),
      headers: {
        ...Utils.headerValue,
        'id': FirebaseAuth.instance.currentUser!.uid,
      },
    );
    final responseData = json.decode(response.body);
    print(responseData);
    // var p = [{_id: 609fbff5d393bc1854edb908, inventory: [{quantity: 30, _id: 609fd8a4e3817717e403008a, productId: 123ef, price: 8000, name: apples}]}];

    return responseData[0]['inventory'] as List;
  }
}
