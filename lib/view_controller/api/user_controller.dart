import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view_controller/api/endpoint.dart';

class UserController {
  Future<http.Response> show(Auth auth) async {
    var uri = Uri.https(EndPoint.value, 'api/user/show');
    int id = auth.id;
    String apiToken = auth.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> showAll(Admin admin) async {
    var uri = Uri.https(EndPoint.value, 'api/admin/user/showAll');
    int id = admin.id;
    String apiToken = admin.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> update(Auth auth, User user) async {
    var uri = Uri.https(EndPoint.value, 'api/user/update');
    int id = auth.id;
    String apiToken = auth.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    request.fields['name'] = user.name.toString();
    request.fields['phone_number'] = user.phone_number.toString();
    request.fields['address'] = user.address.toString();
    request.fields['email'] = user.email.toString();
    request.fields['city'] = user.city.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> verifyUpdateEmail(Auth auth, User user) async {
    var uri = Uri.https(EndPoint.value, 'api/user/verifyUpdateEmail');
    int id = auth.id;
    String apiToken = auth.api_token;
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();
    request.fields['name'] = user.name.toString();
    request.fields['phone_number'] = user.phone_number.toString();
    request.fields['address'] = user.address.toString();
    request.fields['email'] = user.email.toString();
    request.fields['Authorization'] = 'bearer $apiToken';
    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }
}
