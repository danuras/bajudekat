import 'dart:convert';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/auth/enter_code.dart';
import 'package:baju_dekat/view/auth/enter_code_fp.dart';
import 'package:baju_dekat/view/auth/enter_email.dart';
import 'package:baju_dekat/view/auth/register.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view/profile/profile.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/api/raja_ongkir.dart';
import 'package:baju_dekat/view_controller/api/user_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(this._user, this._city, this._auth, this._isAuth,
      this._isAdmin, this._admin, this._gp, this._lopc, this._info,
      {super.key});
  final User _user;
  final String _city;
  final Auth _auth;
  final bool _isAuth;
  final bool _isAdmin;
  final Admin _admin;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  final Information _info;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _email = TextEditingController(text: '');
  final TextEditingController _name = TextEditingController(text: '');
  final TextEditingController _phone_number = TextEditingController(text: '');
  final TextEditingController _address = TextEditingController(text: '');

  final bool _isObsecure = true;

  final _formKey = GlobalKey<FormState>();
  String selectedValue = '';
  int cityId = 1;

  @override
  void initState() {
    _email.text = widget._user.email;
    _name.text = widget._user.name;
    _phone_number.text = widget._user.phone_number;
    _address.text = widget._user.address;
    selectedValue = widget._city;
    cityId = widget._user.city;

    super.initState();
  }

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
                            "Edit Profile",
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
                            controller: _name,
                            decoration: const InputDecoration(
                              labelText: "Nama",
                              prefixIcon: Icon(Icons.person),
                              fillColor: Colors.grey,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _phone_number,
                            decoration: const InputDecoration(
                              labelText: "Nomor Telephon",
                              prefixIcon: Icon(Icons.call),
                              fillColor: Colors.grey,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor Telephon tidak boleh kosong';
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
                                      var data = jsonDecode(
                                              snapshot.data!.body)['rajaongkir']
                                          ['results'];
                                      List<String> items = [];
                                      for (int i = 0; i < data.length; i++) {
                                        items.add(data[i]['city_name']);
                                      }
                                      return CustomDropdownButton2(
                                        buttonWidth: 200,
                                        dropdownWidth: 300,
                                        hint: 'Select City',
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Alamat tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TabletButton(
                              action: () async {
                                try {
                                  if (_formKey.currentState!.validate()) {
                                    widget._user.email = _email.text;
                                    widget._user.name = _name.text;
                                    widget._user.phone_number =
                                        _phone_number.text;
                                    widget._user.address = _address.text;
                                    widget._user.city = cityId;
                                    UserController _uc = UserController();
                                    var response = await _uc.update(
                                      widget._auth,
                                      widget._user,
                                    );
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
                                        ),
                                      );

                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              Menu(
                                            Profile(
                                              widget._user,
                                              widget._auth,
                                              widget._isAdmin,
                                              widget._isAuth,
                                              widget._admin,
                                              widget._gp,
                                              widget._lopc,
                                              widget._info,
                                            ),
                                            false,
                                            widget._auth,
                                            widget._isAdmin,
                                            widget._admin,
                                            widget._gp,
                                            widget._lopc,
                                            widget._info,
                                          ),
                                        ),
                                        ModalRoute.withName('/'),
                                      );
                                    } else if (response.statusCode == 350) {
                                      if (!mounted) {
                                        return;
                                      }

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              EnterCode(
                                            widget._user.email,
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
                                            result['message'].toString(),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                              text: 'Submit',
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
