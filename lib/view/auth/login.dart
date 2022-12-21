import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view/auth/enter_code_fp.dart';
import 'package:baju_dekat/view/auth/enter_email.dart';
import 'package:baju_dekat/view/auth/register.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class Login extends StatefulWidget {
  const Login(
      this._auth, this._isAdmin, this._admin, this._gp, this._lopc, this._info,
      {super.key});
  final Auth _auth;
  final bool _isAdmin;
  final Admin _admin;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  final Information _info;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController(text: '');

  final TextEditingController _password = TextEditingController(text: '');

  bool _isObsecure = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xaa000000),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 500,
              width: 350,
              child: Stack(
                children: [
                  Card(
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email_outlined),
                              fillColor: Colors.grey,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _password,
                            obscureText: _isObsecure,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _isObsecure = !_isObsecure;
                                  setState(() {});
                                },
                                icon: Icon(
                                  _isObsecure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              fillColor: Colors.grey,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: const Alignment(1, 0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EnterEmail(
                                      widget._auth,
                                      widget._isAdmin,
                                      widget._admin,
                                      widget._gp,
                                      widget._lopc,
                                      widget._info,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Lupa Password'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TabletButton(
                              action: () async {
                                if (_formKey.currentState!.validate()) {
                                  AuthController _auth = AuthController();
                                  var response = await _auth.login(
                                    _email.text,
                                    _password.text,
                                  );
                                  var result = jsonDecode(response.body);

                                  if (response.statusCode == 200) {
                                    var box = await Hive.openBox('auth');
                                    box.put(
                                      'id',
                                      result['data']['user']['id'],
                                    );
                                    box.put(
                                      'api_token',
                                      result['data']['api_token'],
                                    );
                                    Auth auth = Auth();
                                    auth.id = box.get('id');
                                    auth.api_token = box.get('api_token');
                                    print(auth.id.toString());
                                    List<Product> _lod =
                                        await widget._gp.getDiscount(0);
                                    List<Product> _lop =
                                        await widget._gp.getAllProduct('%%', 0);
                                    int _dl = await widget._gp.countDiscount();
                                    int _pl =
                                        await widget._gp.countBySearch('%%');

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

                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) => Menu(
                                          Home(
                                            false,
                                            auth,
                                            widget._isAdmin,
                                            widget._admin,
                                            _lod,
                                            _lop,
                                            widget._gp,
                                            _dl,
                                            _pl,
                                            widget._lopc,
                                            widget._info,
                                          ),
                                          false,
                                          auth,
                                          widget._isAdmin,
                                          widget._admin,
                                          widget._gp,
                                          widget._lopc,
                                          widget._info,
                                        ),
                                      ),
                                      ModalRoute.withName('/'),
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
                                }
                              },
                              text: 'Login',
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'or',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TabletButton(
                              text: 'Register',
                              action: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Register(
                                      widget._isAdmin,
                                      widget._admin,
                                      widget._gp,
                                      widget._lopc,
                                      widget._info,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topRight,
                    child: CloseButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
