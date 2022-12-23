import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/auth/enter_code.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/api/raja_ongkir.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';
import 'package:baju_dekat/view_controller/upload_file/pick_image.dart';

class Register extends StatefulWidget {
  const Register(this._isAdmin, this._admin, this._gp, this._lopc, this._info,
      {super.key});
  final bool _isAdmin;
  final Admin _admin;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  final Information _info;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isObsecure = true;

  TextEditingController _name = TextEditingController(text: '');
  TextEditingController _email = TextEditingController(text: '');
  TextEditingController _password = TextEditingController(text: '');
  TextEditingController _phone_number = TextEditingController(text: '');
  TextEditingController _address = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();
  String selectedValue = 'Aceh Barat';
  int cityId = 1;

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
              height: MediaQuery.of(context).size.height - 50,
              width: 350,
              child: Stack(
                children: [
                  // card nya
                  Card(
                    color: const Color(0xff8d9de8),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            const Center(
                              child: Text(
                                "Daftar",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _name,
                              decoration: const InputDecoration(
                                labelText: "Nama",
                                prefixIcon: Icon(Icons.person),
                                fillColor: Colors.grey,
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _email,
                              decoration: const InputDecoration(
                                labelText: "email",
                                prefixIcon: Icon(Icons.email_outlined),
                                fillColor: Colors.grey,
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _password,
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
                              obscureText: _isObsecure,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _phone_number,
                              decoration: const InputDecoration(
                                labelText: "Nomor telephon",
                                prefixIcon: Icon(Icons.call),
                                fillColor: Colors.grey,
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nomor telephon tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Kota : '),
                                  Spacer(),
                                  FutureBuilder(
                                    future: RajaOngkir.getCity(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var data =
                                            jsonDecode(snapshot.data!.body)[
                                                'rajaongkir']['results'];
                                        List<String> items = [];
                                        for (int i = 0; i < data.length; i++) {
                                          items.add(data[i]['city_name']);
                                        }
                                        return CustomDropdownButton2(
                                          buttonWidth: 200,
                                          dropdownWidth: 300,
                                          hint: 'Pilih Kota',
                                          dropdownItems: items,
                                          value: selectedValue,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedValue = value!;

                                              for (int i = 0;
                                                  i < data.length;
                                                  i++) {
                                                if (items[i] == value) {
                                                  cityId = i + 1;
                                                }
                                              }
                                            });
                                            print(cityId);
                                          },
                                        );
                                      } else {
                                        return Text('Loading...');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              controller: _address,
                              decoration: const InputDecoration(
                                labelText: "Alamat",
                                prefixIcon: Icon(Icons.home),
                                fillColor: Colors.grey,
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Alamat tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                              ),
                              child: Center(
                                // button submit
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
                                        AuthController auth = AuthController();

                                        var response = await auth.register(
                                          _name.text,
                                          _email.text,
                                          _password.text,
                                          _phone_number.text,
                                          cityId,
                                          _address.text,
                                        );
                                        var result = jsonDecode(response.body);

                                        if (response.statusCode == 200) {
                                          Auth auth = Auth();
                                          auth.id =
                                              result['data']['user']['id'];
                                          auth.api_token =
                                              result['data']['api_token'];
                                          var box = await Hive.openBox('auth');
                                          box.put('id', auth.id);
                                          box.put('api_token', auth.api_token);
                                          User user = User.fromJson(
                                            result['data']['user'],
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  result['message'].toString()),
                                            ),
                                          );
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  EnterCode(
                                                user.email,
                                                auth,
                                                widget._isAdmin,
                                                widget._admin,
                                                widget._gp,
                                                widget._lopc,
                                                widget._info,
                                              ),
                                            ),
                                          );
                                        } else {
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
                                    child: const Text('Daftar'),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
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
