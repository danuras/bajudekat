import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/auth/register.dart';
import 'package:baju_dekat/view/auth/reset_password.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class EnterCodeFP extends StatefulWidget {
  EnterCodeFP(this._email, this._auth, this._isAdmin, this._admin, this._gp,
      this._lopc, this._info,
      {super.key});
  String _email;
  Auth _auth;
  bool _isAdmin;
  Admin _admin;
  GetProduct _gp;
  List<ProductCategories> _lopc;
  Information _info;

  @override
  State<EnterCodeFP> createState() => _EnterCodeFPState();
}

class _EnterCodeFPState extends State<EnterCodeFP> {
  final TextEditingController _code = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff737fb3),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 500,
              width: 350,
              child: Stack(
                children: [
                  Card(
                    color: const Color(0xff8d9de8),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Verifikasi",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            TextFormField(
                              controller: _code,
                              decoration: const InputDecoration(
                                labelText: "Security code",
                                prefixIcon: Icon(Icons.email_outlined),
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Security code tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            Align(
                              alignment: const Alignment(1, 0),
                              child: TextButton(
                                onPressed: () async {
                                  AuthController _auth = AuthController();
                                  await _auth
                                      .sendEmailVerification(widget._email);
                                  print('kode dikirim');
                                },
                                child: const Text('Kirim lagi',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 40,
                                  width: 180,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff737fb3),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        AuthController _auth = AuthController();
                                        var response = await _auth.verifyEmail(
                                            widget._email, _code.text);
                                        var result = jsonDecode(response.body);

                                        if (response.statusCode == 200) {
                                          if (!mounted) {
                                            return;
                                          }
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                result['message'].toString(),
                                              ),
                                              behavior: SnackBarBehavior
                                                  .floating, // Add this line
                                            ),
                                          );
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ResetPassword(
                                                _code.text,
                                                widget._email,
                                                widget._auth,
                                                widget._isAdmin,
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  result['message'].toString()),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text('Verifikasi'),
                                  ),
                                )),
                          ],
                        ),
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
