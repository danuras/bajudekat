import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:path/path.dart';

import 'package:baju_dekat/view_controller/api/endpoint.dart';

class ProductController {
  Future<http.Response> create(
      Admin admin, Product product, List<int> image, String fileName) async {
    var uri = Uri.https(EndPoint.value, 'api/admin/product/create');
    int id = admin.id;
    String apiToken = admin.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    print('okok' + id.toString());
    request.fields['name'] = product.name.toString();
    request.fields['categories_name'] = product.categories_name.toString();
    request.fields['description'] = product.description.toString();
    request.fields['buy_price'] = product.buy_price.toString();
    request.fields['sell_price'] = product.sell_price.toString();
    request.fields['currency'] = product.currency.toString();
    request.fields['stock'] = product.stock.toString();
    request.fields['weight'] = product.weight.toString();
    request.fields['discount'] = product.discount.toString();
    request.fields['discount_expired_at'] =
        product.discount_expired_at.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    if (image != null) {
      // get file length
      var multipartFile = http.MultipartFile.fromBytes(
        'image_url',
        image,
        filename: basename('images/product/${fileName}'),
      );

      // add file to multipart
      request.files.add(multipartFile);
    }
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> update(Admin admin, Product product, int product_id,
      List<int> image, String fileName) async {
    var uri = Uri.https(EndPoint.value, 'api/admin/product/update');
    int id = admin.id;
    String apiToken = admin.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    request.fields['name'] = product.name.toString();
    request.fields['product_id'] = product_id.toString();
    request.fields['categories_name'] = product.categories_name.toString();
    request.fields['description'] = product.description.toString();
    request.fields['buy_price'] = product.buy_price.toString();
    request.fields['sell_price'] = product.sell_price.toString();
    request.fields['currency'] = product.currency.toString();
    request.fields['stock'] = product.stock.toString();
    request.fields['weight'] = product.weight.toString();
    request.fields['discount'] = product.discount.toString();
    request.fields['discount_expired_at'] =
        product.discount_expired_at.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    if (image != null) {
      // get file length
      var multipartFile = http.MultipartFile.fromBytes(
        'image_url',
        image,
        filename: basename('images/product/${fileName}'),
      );

      // add file to multipart
      request.files.add(multipartFile);
    }
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> delete(Admin admin, int product_id) async {
    var uri = Uri.https(EndPoint.value, 'api/admin/product/delete');
    int id = admin.id;
    String apiToken = admin.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    request.fields['product_id'] = product_id.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showById(int product_id, int cust_id) async {
    var uri = Uri.https(EndPoint.value, 'api/user/product/showById');
    var request = http.MultipartRequest('POST', uri);
    request.fields['product_id'] = product_id.toString();
    request.fields['cust_id'] = cust_id.toString();
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> countDiscount() async {
    var uri = Uri.https(EndPoint.value, 'api/user/product/countAllDiscount');
    var request = http.MultipartRequest('POST', uri);
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showAllDiscount(int count) async {
    var uri = Uri.https(EndPoint.value, 'api/user/product/showAllDiscount');
    var request = http.MultipartRequest('POST', uri);
    request.fields['count'] = count.toString();
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> countByCategory(int categories_id) async {
    var uri = Uri.https(EndPoint.value, 'api/user/product/countByCategory');
    var request = http.MultipartRequest('POST', uri);
    request.fields['categories_id'] = categories_id.toString();
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showAllByCategory(int categories_id, int count) async {
    var uri = Uri.https(EndPoint.value, 'api/user/product/showAllByCategory');
    var request = http.MultipartRequest('POST', uri);
    request.fields['categories_id'] = categories_id.toString();
    request.fields['count'] = count.toString();
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> countBySearch(String search) async {
    var uri = Uri.https(EndPoint.value, 'api/user/product/countBySearch');
    var request = http.MultipartRequest('POST', uri);
    request.fields['search'] = search.toString();
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showBySearch(String search, int count) async {
    var uri = Uri.https(EndPoint.value, 'api/user/product/showBySearch');
    var request = http.MultipartRequest('POST', uri);
    request.fields['search'] = search.toString();
    request.fields['count'] = count.toString();
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }
}
