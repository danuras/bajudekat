import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view/auth/login.dart';
import 'package:baju_dekat/view_controller/api/endpoint.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class AuthController {
  Future<http.Response> login(String email, String password) async {
    var uri = Uri.parse('${EndPoint.value}user/auth/login');
    var request = http.MultipartRequest('POST', uri);

    request.fields['email'] = email;
    request.fields['password'] = password;

    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> sendEmailVerification(String email) async {
    var uri = Uri.parse('${EndPoint.value}user/auth/sendEmailVerification');
    var request = http.MultipartRequest('POST', uri);

    request.fields['email'] = email;

    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> verifyEmail(String email, String token) async {
    var uri = Uri.parse('${EndPoint.value}user/auth/verifyEmail');
    var request = http.MultipartRequest('POST', uri);

    request.fields['email'] = email;
    request.fields['token'] = token;

    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<void> logout(Auth auth) async {
    var box = await Hive.openBox('auth');
    box.put('id', '');
    box.put('api_token', '');
    auth.id = 0;
    auth.api_token = '';
  }

  Future<http.Response> register(
    String name,
    String email,
    String password,
    String phone_number,
    int city,
    String address,
  ) async {
    // string to uri
    var uri = Uri.parse("${EndPoint.value}user/auth/register");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['phone_number'] = phone_number;
    request.fields['city'] = city.toString();
    request.fields['address'] = address;

    var hasil = await request.send();
    // send
    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> reqeustForgetPassword(String email) async {
    var uri = Uri.parse('${EndPoint.value}user/auth/requestForgetPassword');
    var request = http.MultipartRequest('POST', uri);

    request.fields['email'] = email;

    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> verifyUpdatePassword(
      String email, String password, String token) async {
    var uri = Uri.parse('${EndPoint.value}user/auth/verifyUpdatePassword');
    var request = http.MultipartRequest('POST', uri);

    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['token'] = token;

    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  void isAuth(
      bool isAuth,
      Auth auth,
      BuildContext context,
      bool isAdmin,
      Admin admin,
      GetProduct gp,
      List<ProductCategories> _lopc,
      Information _info) {
    if (isAuth) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, __, ___) {
            return Login(
              auth,
              isAdmin,
              admin,
              gp,
              _lopc,
              _info,
            );
          },
        ),
      );
    }
  }
}
