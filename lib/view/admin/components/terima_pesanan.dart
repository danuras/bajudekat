import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view/admin/menejemen_produk.dart';
import 'package:baju_dekat/view/auth/register.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view_controller/api/product_controller.dart';
import 'package:baju_dekat/view_controller/api/transaction_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';
import 'package:baju_dekat/view_controller/upload_file/pick_image.dart';

class TerimaPesanan extends StatefulWidget {
  const TerimaPesanan(this._admin, this._isAdmin, this._auth, this._isAuth,
      this._gp, this._lopc, this._info, this._ti,
      {super.key});
  final Admin _admin;
  final bool _isAdmin;
  final Auth _auth;
  final bool _isAuth;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  final Information _info;
  final int _ti;

  @override
  State<TerimaPesanan> createState() => _TerimaPesananState();
}

class _TerimaPesananState extends State<TerimaPesanan> {
  final TextEditingController _nomor_resi = TextEditingController(text: '');

  bool _isObsecure = true;
  String _image_url = '';
  File _image = File('assets/default_product.png');

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('MP: ' + widget._admin.id.toString());
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          children: [
                            const Center(
                              child: Text(
                                "Terima Pesanan",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            TextFormField(
                              controller: _nomor_resi,
                              decoration: InputDecoration(
                                labelText: "Nomor Resi",
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nomor Resi tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TabletButton(
                                action: () async {
                                  if (_formKey.currentState!.validate()) {
                                    TransactionController tc =
                                        TransactionController();
                                    var response = await tc.updateStatusDikirim(
                                      widget._admin,
                                      widget._ti,
                                      _nomor_resi.text,
                                    );

                                    if (response.statusCode == 200) {
                                      var result = jsonDecode(response.body);
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

                                      Navigator.of(context).pop();
                                    } else {
                                      var result = jsonDecode(response.body);
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
                                text: 'Submit',
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
