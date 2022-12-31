import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/auth/enter_code.dart';
import 'package:baju_dekat/view/auth/enter_code_fp.dart';
import 'package:baju_dekat/view/auth/register.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class EnterEmail extends StatefulWidget {
  EnterEmail(
      this._auth, this._isAdmin, this._admin, this._gp, this._lopc, this._info,
      {super.key});
  Auth _auth;
  bool _isAdmin;
  Admin _admin;
  GetProduct _gp;
  List<ProductCategories> _lopc;
  Information _info;

  @override
  State<EnterEmail> createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
  final TextEditingController _email = TextEditingController(text: '');

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
                  // card nya
                  Card(
                    color: const Color(0xff8d9de8),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      // form email
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Masukan Email",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            TextFormField(
                              controller: _email,
                              decoration: const InputDecoration(
                                labelText: "email",
                                prefixIcon: Icon(Icons.email_outlined),
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'email tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 8.0 , 8.0, 20.0),
                              // button ok
                              child: Container(
                                padding: const EdgeInsets.only(top: 30.0),
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
                                        var response = await _auth
                                            .reqeustForgetPassword(_email.text);

                                        if (response.statusCode == 200) {
                                          var result =
                                              jsonDecode(response.body);

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
                                                  EnterCodeFP(
                                                _email.text,
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
                                          var result =
                                              jsonDecode(response.body);

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
                                    child: const Text('OK'),
                                  ),
                                ),
                              ),
                            ),
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
