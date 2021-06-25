import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class NFTNetwork {
    static String baseURL = 'https://api.opensea.io/api/v1/';

    static Future<List> getFeaturedData() async {
      List<dynamic> imgList = [];

      var url = Uri.parse(baseURL + 'bundles?on_sale=true&limit=20&offset=0');
      var response = await http.get(url);
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      final responseBody = json.decode(response.body);

      final bundles = responseBody["bundles"];
      // print(responseBody["bundles"][0]["assets"][0]["image_url"]);

      for(var i = 0; i< bundles.length; i++) {
        // print(responseBody["bundles"][i]["assets"][0]["image_url"]);
        imgList.add(responseBody["bundles"][i]["assets"][0]["image_url"]);
      }
      print(imgList);
      return imgList;
    }

}