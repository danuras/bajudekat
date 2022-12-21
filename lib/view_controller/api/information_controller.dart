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

class InformationController {
  Future<http.Response> show() async {
    var uri = Uri.parse('${EndPoint.value}user/information/show');
    var request = http.MultipartRequest('POST', uri);

    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  Future<http.Response> update(Information information, Admin admin) async {
    var uri = Uri.parse('${EndPoint.value}admin/information/update');
    var request = http.MultipartRequest('POST', uri);

    request.fields['short_description'] = information.short_description;
    request.fields['description'] = information.description;
    request.fields['no_telp'] = information.no_telp;
    request.fields['email'] = information.email;
    request.fields['link_market_place'] = information.link_market_place;
    request.fields['link_tiktok'] = information.link_tiktok;
    request.fields['link_instagram'] = information.link_instagram;
    request.fields['link_facebook'] = information.link_facebook;
    request.fields['link_twitter'] = information.link_twitter;
    request.fields['link_pinterest'] = information.link_pinterest;
    request.fields['link_linkedin'] = information.link_linkedin;
    request.fields['link_youtube'] = information.link_youtube;
    request.fields['city'] = information.city;
    request.fields['address'] = information.address;
    request.headers['Authorization'] = 'bearer ' + admin.api_token;
    request.fields['id'] = admin.id.toString();
    print('id' + admin.id.toString());

    var hasil = await request.send();

    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }
}
