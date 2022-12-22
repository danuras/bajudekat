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

class ProductTransactionController {
  Future<http.Response> create(
      Auth auth, ProductTransaction producttransaction) async {
    var uri = Uri.https(EndPoint.value, 'api/user/producttransaction/create');
    int id = auth.id;
    String apiToken = auth.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['cust_id'] = id.toString();
    request.fields['buy_price'] = producttransaction.buy_price.toString();
    request.fields['sell_price'] = producttransaction.sell_price.toString();
    request.fields['currency'] = producttransaction.currency;
    request.fields['amount'] = producttransaction.amount.toString();
    request.fields['weight'] = producttransaction.weight.toString();
    request.fields['product_id'] = producttransaction.product_id.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showBasket(Auth auth) async {
    var uri =
        Uri.https(EndPoint.value, 'api/user/producttransaction/showBasket');
    int id = auth.id;
    String apiToken = auth.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['cust_id'] = id.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showByTransactionId(int transaction_id) async {
    var uri = Uri.https(
        EndPoint.value, 'api/admin/producttransaction/showByTransactionId');
    var request = http.MultipartRequest('POST', uri);
    request.fields['transaction_id'] = transaction_id.toString();
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  /* Future<http.Response> createByCashier(
    Admin admin,
    ProductTransaction producttransaction,
    Transaction transaction,
  ) async {
    var uri =
        Uri.https(EndPoint.value,'api/admin/producttransaction/createByCashier');
    int id = admin.id;
    String apiToken = admin.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    request.fields['cust_id'] = transaction.cust_id.toString();
    request.fields['payment'] = transaction.payment.toString();
    request.fields['buy_price'] = producttransaction.buy_price.toString();
    request.fields['sell_price'] = producttransaction.sell_price.toString();
    request.fields['currency'] = producttransaction.currency.toString();
    request.fields['amount'] = producttransaction.amount.toString();
    request.fields['product_id'] = producttransaction.product_id.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }
 */
  Future<http.Response> delete(Auth auth, int product_transaction_id) async {
    var uri = Uri.https(EndPoint.value, 'api/user/producttransaction/delete');
    int id = auth.id;
    String apiToken = auth.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['cust_id'] = id.toString();
    request.fields['pt_id'] = product_transaction_id.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }
/* 
  Future<http.Response> deleteByCashier(
      Admin admin, int transaction_id, int product_transaction_id) async {
    var uri = Uri.https(EndPoint.value,'api/admin/producttransaction/delete');
    int id = admin.id;
    String apiToken = admin.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    request.fields['product_transaction_id'] =
        product_transaction_id.toString();
    request.fields['transaction_id'] = transaction_id.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  } */
}
