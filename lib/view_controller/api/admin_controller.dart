import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/view/auth/login.dart';
import 'package:baju_dekat/view_controller/api/endpoint.dart';

class AdminController {
  Future<http.Response> login(String email, String password) async {
    var uri = Uri.https(EndPoint.value, 'api/admin/login');
    var request = http.MultipartRequest('POST', uri);

    request.fields['email'] = email;
    request.fields['password'] = password;

    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<void> logout(Admin admin) async {
    var box = await Hive.openBox('admin');
    box.put('id', '');
    box.put('api_token', '');
    admin.id = 0;
    admin.api_token = '';
  }
}
