import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/auth/login.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/component/virture_loading.dart';
import 'package:baju_dekat/view/navbar.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/api/user_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class Contact extends StatefulWidget {
  Contact(this._admin, this._isAdmin, this._auth, this._isAuth, this._gp,
      this._lopc, this._info,
      {super.key});
  final Admin _admin;
  final bool _isAdmin;
  final Auth _auth;
  final bool _isAuth;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  final Information _info;

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final double coverHeight = 280, profileHeight = 144;
  late User _user;
  late UserController _userController;
  late Future<http.Response> _bar;

  @override
  void initState() {
    _userController = UserController();
    super.initState();
    //_bar = _userController.show(widget.auth);
  }

  void _retry() {
    setState(() {
      //_bar = _userController.show(widget.auth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: (MediaQuery.of(context).size.width > 900)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: buildContent(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: NavBar(
                      widget._lopc,
                      widget._admin,
                      widget._isAdmin,
                      widget._auth,
                      widget._isAuth,
                      widget._gp,
                      widget._info,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                buildContent(),
                NavBar(
                  widget._lopc,
                  widget._admin,
                  widget._isAdmin,
                  widget._auth,
                  widget._isAuth,
                  widget._gp,
                  widget._info,
                ),
              ],
            ),
    );
  }

  Widget buildContent() => SizedBox(
        width: double.infinity * 2 / 3,
        child: Card(
          elevation: 3.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 8),
              Text(
                'Contact',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Align(alignment: Alignment.centerLeft, child: buildInfo()),
              SizedBox(height: 32),
            ],
          ),
        ),
      );

  Widget buildInfo() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Information',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Table(
              border: TableBorder(
                horizontalInside: BorderSide(
                  width: 1,
                  color: Color(0xffaaaaaa),
                  style: BorderStyle.solid,
                ),
                top: BorderSide(
                  width: 1,
                  color: Color(0xffaaaaaa),
                  style: BorderStyle.solid,
                ),
                left: BorderSide(
                  width: 1,
                  color: Color(0xffaaaaaa),
                  style: BorderStyle.solid,
                ),
                bottom: BorderSide(
                  width: 1,
                  color: Color(0xffaaaaaa),
                  style: BorderStyle.solid,
                ),
                right: BorderSide(
                  width: 1,
                  color: Color(0xffaaaaaa),
                  style: BorderStyle.solid,
                ),
              ),
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        widget._info.email,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Phone Number',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        widget._info.no_telp,
                      ),
                    ),
                  ],
                ),
                /* TableRow(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'information.address',
                      ),
                    ),
                  ],
                ) */
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
}
