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

class TransactionController {
  Future<http.Response> updateStatusPesan(
    Auth auth,
    Transaction transaction,
  ) async {
    var uri =
        Uri.https(EndPoint.value, 'api/user/transaction/updateStatusPesan');
    int id = auth.id;
    String apiToken = auth.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['transaction_id'] = transaction.id.toString();
    request.fields['cust_id'] = id.toString();
    request.fields['address'] = transaction.address;
    request.fields['kurir'] = transaction.kurir;
    request.fields['total'] = transaction.total.toString();
    request.fields['ongkos'] = transaction.ongkos.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> updateStatusDikirim(
    Admin admin,
    int tid,
    String nomor_resi,
  ) async {
    var uri =
        Uri.https(EndPoint.value, 'api/admin/transaction/updateStatusDikirim');
    int id = admin.id;
    String apiToken = admin.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['transaction_id'] = tid.toString();
    request.fields['id'] = id.toString();
    request.fields['nomor_resi'] = nomor_resi;
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  /* Future<http.Response> createByCashier(
    Admin admin,
    Transaction transaction,
  ) async {
    var uri = Uri.https(EndPoint.value,'api/admin/transaction/createByCashier');
    int id = admin.id;
    String apiToken = admin.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['transaction_id'] = transaction.id.toString();
    request.fields['id'] = id.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  } */

  Future<http.Response> countByUserId(Auth auth, int status) async {
    var uri = Uri.https(EndPoint.value, 'api/user/transaction/countByUserId');
    int id = auth.id;
    String apiToken = auth.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['cust_id'] = id.toString();
    request.fields['status'] = status.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showAllByUserId(
    Auth auth,
    int status,
    int count,
  ) async {
    var uri = Uri.https(EndPoint.value, 'api/user/transaction/showAllByUserId');
    int id = auth.id;
    String apiToken = auth.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['cust_id'] = id.toString();
    request.fields['status'] = status.toString();
    request.fields['count'] = count.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> countByAll(Admin admin, int status) async {
    var uri = Uri.https(EndPoint.value, 'api/user/transaction/countByUserId');
    int id = admin.id;
    String apiToken = admin.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    request.fields['status'] = status.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showAll(Admin admin, int status, int count) async {
    var uri = Uri.https(EndPoint.value, 'api/admin/transaction/showAll');
    int id = admin.id;
    String apiToken = admin.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    request.fields['status'] = status.toString();
    request.fields['count'] = count.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }
}
