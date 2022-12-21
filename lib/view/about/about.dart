import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/admin/login_admin.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view/navbar.dart';
import 'package:baju_dekat/view_controller/api/admin_controller.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/api/user_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class About extends StatefulWidget {
  const About(this._auth, this._admin, this._isAuth, this._isAdmin, this._gp,
      this._lopc, this._info,
      {super.key});
  final Auth _auth;
  final Admin _admin;
  final bool _isAuth;
  final bool _isAdmin;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  final Information _info;

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
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
                        width: 20,
                      ),
                      (!widget._isAdmin)
                          ? TabletButton(
                              action: () async {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (context, __, ___) {
                                      return LoginAdmin(
                                        widget._auth,
                                        widget._admin,
                                        widget._isAuth,
                                        widget._gp,
                                        widget._lopc,
                                        widget._info,
                                      );
                                    },
                                  ),
                                );
                              },
                              text: 'Login Admin',
                            )
                          : TabletButton(
                              action: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text(
                                      'Apakah anda yakin ingin logout'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        AdminController ac = AdminController();
                                        await ac.logout(widget._admin);
                                        setState(() {});
                                        print('logout');

                                        List<Product> _lod =
                                            await widget._gp.getDiscount(0);
                                        List<Product> _lop = await widget._gp
                                            .getAllProduct('%%', 0);
                                        int _dl =
                                            await widget._gp.countDiscount();
                                        int _pl = await widget._gp
                                            .countBySearch('%%');

                                        if (!mounted) {
                                          return;
                                        }

                                        Navigator.pop(context, 'OK');

                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: ((context) => Menu(
                                                  Home(
                                                    widget._isAuth,
                                                    widget._auth,
                                                    false,
                                                    widget._admin,
                                                    _lod,
                                                    _lop,
                                                    widget._gp,
                                                    _dl,
                                                    _pl,
                                                    widget._lopc,
                                                    widget._info,
                                                  ),
                                                  widget._isAuth,
                                                  widget._auth,
                                                  false,
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
                              text: 'Logout Admin',
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
              'Description',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              widget._info.description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Address',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              widget._info.address,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
}
