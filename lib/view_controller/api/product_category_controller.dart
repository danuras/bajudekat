import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_transaction.dart';
import 'package:baju_dekat/model/transaction.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:path/path.dart';

import 'package:baju_dekat/view_controller/api/endpoint.dart';

class ProductCategoryController {
  Future<http.Response> create(Admin admin, String categories_name) async {
    var uri = Uri.https(EndPoint.value, 'api/admin/productcategory/create');
    int id = admin.id;
    String apiToken = admin.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    request.fields['categories_name'] = categories_name;
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showAll() async {
    var uri = Uri.https(EndPoint.value, 'api/user/productcategory/showAll');
    var request = http.MultipartRequest('POST', uri);
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showByName(String categories_name) async {
    var uri = Uri.https(EndPoint.value, 'api/user/productcategory/showByName');
    var request = http.MultipartRequest('POST', uri);
    request.fields['categories_name'] = categories_name;
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showById(int id) async {
    var uri = Uri.https(EndPoint.value, 'api/user/productcategory/showById');
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }
}
