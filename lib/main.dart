import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/api/information_controller.dart';
import 'package:baju_dekat/view_controller/api/product_category_controller.dart';
import 'package:baju_dekat/view_controller/api/product_controller.dart';
import 'package:baju_dekat/view_controller/api/raja_ongkir.dart';
import 'package:baju_dekat/view_controller/api/user_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_category.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

import 'view/menu.dart';

void main() async {
  print('ok');
  await Hive.initFlutter();

  Auth _auth = Auth();
  Admin _admin = Admin();
  bool isAuth = false;
  bool isAdmin = false;
  ProductController _pc = ProductController();
  ProductCategoryController _pcc = ProductCategoryController();
  InformationController ic = InformationController();

  var infoRespon = await ic.show();
  print('ok');

  var infoResult = jsonDecode(infoRespon.body);

  Information info = Information.fromJson({
    'short_description': infoResult['data'][0]['short_description'],
    'description': infoResult['data'][0]['description'],
    'no_telp': infoResult['data'][0]['no_telp'],
    'email': infoResult['data'][0]['email'],
    'link_market_place': infoResult['data'][0]['link_market_place'],
    'link_tiktok': infoResult['data'][0]['link_tiktok'],
    'link_instagram': infoResult['data'][0]['link_instagram'],
    'link_facebook': infoResult['data'][0]['link_facebook'],
    'link_twitter': infoResult['data'][0]['link_twitter'],
    'link_pinterest': infoResult['data'][0]['link_pinterest'],
    'link_linkedin': infoResult['data'][0]['link_linkedin'],
    'link_youtube': infoResult['data'][0]['link_youtube'],
    'city': infoResult['data'][0]['city'],
    'address': infoResult['data'][0]['address'],
  });

  var box = await Hive.openBox('auth');
  try {
    _auth.id = box.get('id');
  } catch (e) {
    _auth.id = 0;
  }
  _auth.api_token = box.get('api_token') ?? '';
  var boxAdmin = await Hive.openBox('admin');
  try {
    _admin.id = boxAdmin.get('id');
  } catch (e) {
    _admin.id = 0;
  }
  _admin.api_token = boxAdmin.get('api_token') ?? '';
  print('main' + _auth.id.toString());
  if (_auth.id == 0 || _auth.api_token == '') {
    isAuth = true;
  }
  if (_admin.id != 0 && _admin.api_token != '') {
    isAdmin = true;
  }
  GetProduct _gp = GetProduct(_pc, _pcc);
  GetCategory _gc = GetCategory(ProductCategoryController());
  List<ProductCategories> _lopc = await _gc.showAll();
  List<Product> _lod = await _gp.getDiscount(0);
  List<Product> _lop = await _gp.getAllProduct('%%', 0);
  int _dl = await _gp.countDiscount();
  int _pl = await _gp.countBySearch('%%');
  runApp(
    MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      home: SafeArea(
        child: Menu(
            Home(isAuth, _auth, isAdmin, _admin, _lod, _lop, _gp, _dl, _pl,
                _lopc, info),
            isAuth,
            _auth,
            isAdmin,
            _admin,
            _gp,
            _lopc,
            info),
      ),
    ),
  ); /* 
  try {
    print((await RajaOngkir.getCity()).body.toString());
  } catch (e) {
    print(e.toString());
  }
  runApp(MaterialApp(
    home: Scaffold(
      body: Text('okok'),
    ),
  )); */
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
