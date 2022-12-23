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
      // background login
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
                  // card login
                  Card(
                    elevation: 20.0,
                    color: const Color(0xff8d9de8),
                    shape: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // text login
                          const Text(
                            "Masuk",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          // email
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              controller: _email,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          // password
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              controller: _password,
                              obscureText: _isObsecure,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: const TextStyle(color: Colors.black),
                                prefixIcon: const Icon(Icons.lock_outline, 
                                color: Colors.black,
                                ),
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
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          // lupa password
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 15.0, 5),
                            child: Align(
                              alignment: const Alignment(1, 0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
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
                                child: const TextButton(
                                    onPressed: null,
                                    child: Text(
                                      'Lupa Password',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              // button masuk
                              child: SizedBox(
                                height: 40,
                                width: 180,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff737fb3),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Text(
                                    'Masuk',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () async {
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
                                        List<Product> _lop = await widget._gp
                                            .getAllProduct('%%', 0);
                                        int _dl =
                                            await widget._gp.countDiscount();
                                        int _pl = await widget._gp
                                            .countBySearch('%%');

                                        if (!mounted) {
                                          return;
                                        }

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result['message'].toString(),
                                            ),
                                          ),
                                        );

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                Menu(
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result['message'].toString(),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              )),
                          // atau
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'atau',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // button daftar
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 40,
                                width: 180,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff737fb3),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Text(
                                    'Daftar',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
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
                              )),
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
