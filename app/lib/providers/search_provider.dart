import 'dart:convert';

import 'package:app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

//
class SearchProvider {
  static Future<List<String>> getSearchData({required String name}) async {
    final response = await http.get(
      Uri.parse(Utils.backendUrl + '/api/search/${name}'),
      headers: {
        ...Utils.headerValue,
        'id': FirebaseAuth.instance.currentUser!.uid,
      },
    );
    final responseData = json.decode(response.body);
    final listOfProducts = responseData['inventory'] as List<Map<String, dynamic>>;

    final listOfProductsName = listOfProducts.map((eachItem) => eachItem['name']).toList() as List<String>;
    print(listOfProductsName);

    return listOfProductsName;
  }
}
