import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view/navbar.dart';
import 'package:baju_dekat/view/profile/edit_profile.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/api/raja_ongkir.dart';
import 'package:baju_dekat/view_controller/api/user_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

import '../../model/information.dart';

class Profile extends StatefulWidget {
  Profile(this._user, this.auth, this._isAdmin, this._isAuth, this._admin,
      this._gp, this._lopc, this._info,
      {super.key});
  User _user;
  Auth auth;
  bool _isAdmin;
  bool _isAuth;
  Admin _admin;
  GetProduct _gp;
  List<ProductCategories> _lopc;
  Information _info;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final double coverHeight = 280, profileHeight = 144;
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
                      widget.auth,
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
                  widget.auth,
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
                widget._user.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'ID: ' + widget._user.id.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Align(alignment: Alignment.centerLeft, child: buildInfo()),
              Padding(
                padding: const EdgeInsets.only(
                  right: 50.0,
                  top: 50.0,
                ),
                child: Material(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 180,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff737fb3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () async {
                            var response = await RajaOngkir.getCityById(
                              widget._user.city,
                            );
                            var result = jsonDecode(response.body);
                            if (response.statusCode == 200) {
                              if (!mounted) {
                                return;
                              }
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (context, __, ___) =>
                                      EditProfile(
                                    widget._user,
                                    result['rajaongkir']['results']
                                        ['city_name'],
                                    widget.auth,
                                    widget._isAdmin,
                                    widget._isAuth,
                                    widget._admin,
                                    widget._gp,
                                    widget._lopc,
                                    widget._info,
                                  ),
                                ),
                              );
                            } else {
                              if (!mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result['message'].toString(),
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text('Edit'),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        height: 40,
                        width: 180,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff737fb3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Logout'),
                              content:
                                  const Text('Apakah anda yakin ingin logout'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    AuthController authController =
                                        AuthController();
                                    await authController.logout(widget.auth);
                                    setState(() {});
                                    print('logout');
                                    List<Product> _lod =
                                        await widget._gp.getDiscount(0);
                                    List<Product> _lopc =
                                        await widget._gp.getAllProduct('%%', 0);
                                    int _dl = await widget._gp.countDiscount();
                                    int _pl =
                                        await widget._gp.countBySearch('%%');

                                    if (!mounted) {
                                      return;
                                    }

                                    Navigator.pop(context, 'OK');

                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: ((context) => Menu(
                                              Home(
                                                true,
                                                widget.auth,
                                                widget._isAdmin,
                                                widget._admin,
                                                _lod,
                                                _lopc,
                                                widget._gp,
                                                _dl,
                                                _pl,
                                                widget._lopc,
                                                widget._info,
                                              ),
                                              true,
                                              widget.auth,
                                              widget._isAdmin,
                                              widget._admin,
                                              widget._gp,
                                              widget._lopc,
                                              widget._info,
                                            )),
                                      ),
                                    );

                                    _userController = UserController();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),
                          child: const Text('Keluar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            Text(
              'Informasi Anda',
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
                        widget._user.email,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Alamat',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        widget._user.address,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Nomor HP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        widget._user.phone_number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
}
