import 'dart:convert';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
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
import 'package:baju_dekat/view_controller/api/information_controller.dart';
import 'package:baju_dekat/view_controller/api/raja_ongkir.dart';
import 'package:baju_dekat/view_controller/api/user_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class InformationWeb extends StatefulWidget {
  InformationWeb(this._auth, this._admin, this._isAuth, this._isAdmin, this._gp,
      this._lopc, this._info, this._city);
  final Auth _auth;
  final Admin _admin;
  final bool _isAuth;
  final bool _isAdmin;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  Information _info;
  String _city;

  @override
  State<InformationWeb> createState() => _InformationWebState();
}

class _InformationWebState extends State<InformationWeb> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _sd = TextEditingController(text: '');
  TextEditingController _des = TextEditingController(text: '');
  TextEditingController _nt = TextEditingController(text: '');
  TextEditingController _em = TextEditingController(text: '');
  TextEditingController _lmp = TextEditingController(text: '');
  TextEditingController _lti = TextEditingController(text: '');
  TextEditingController _li = TextEditingController(text: '');
  TextEditingController _lf = TextEditingController(text: '');
  TextEditingController _ltw = TextEditingController(text: '');
  TextEditingController _lp = TextEditingController(text: '');
  TextEditingController _ll = TextEditingController(text: '');
  TextEditingController _ly = TextEditingController(text: '');
  TextEditingController _c = TextEditingController(text: '');
  TextEditingController _ad = TextEditingController(text: '');

  var selectedValue;
  int cityId = 1;

  @override
  void initState() {
    super.initState();
    //_bar = _userController.show(widget.auth);
    _sd.text = widget._info.short_description;
    _des.text = widget._info.description;
    _nt.text = widget._info.no_telp;
    _em.text = widget._info.email;
    _lmp.text = widget._info.link_market_place;
    _lti.text = widget._info.link_tiktok;
    _li.text = widget._info.link_instagram;
    _lf.text = widget._info.link_facebook;
    _ltw.text = widget._info.link_twitter;
    _lp.text = widget._info.link_pinterest;
    _ll.text = widget._info.link_linkedin;
    _ly.text = widget._info.link_youtube;
    _c.text = widget._info.city;
    _ad.text = widget._info.address;
    selectedValue = widget._city;
    cityId = int.parse(widget._info.city);
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
              Align(
                alignment: Alignment.centerLeft,
                child: buildInfo(),
              ),
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
                      TabletButton(
                        action: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Simpan'),
                            content: const Text(
                                'Apakah anda yakin ingin menyimpan perubahan'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    InformationController ic =
                                        InformationController();
                                    widget._info = Information.fromJson({
                                      'short_description': _sd.text,
                                      'description': _des.text,
                                      'no_telp': _nt.text,
                                      'email': _em.text,
                                      'link_market_place': _lmp.text,
                                      'link_tiktok': _lti.text,
                                      'link_instagram': _li.text,
                                      'link_facebook': _lf.text,
                                      'link_twitter': _ltw.text,
                                      'link_pinterest': _lp.text,
                                      'link_linkedin': _ll.text,
                                      'link_youtube': _ly.text,
                                      'city': cityId.toString(),
                                      'address': _ad.text,
                                    });
                                    var response = await ic.update(
                                      widget._info,
                                      widget._admin,
                                    );
                                    if (response.statusCode == 200) {
                                      var result = jsonDecode(response.body);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            result['message'].toString(),
                                          ),
                                        ),
                                      );
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    } else {
                                      var result = jsonDecode(response.body);

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
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                        text: 'Simpan',
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Text(
                  'Informasi Web',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 50,
                  maxWidth: 1200,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi Singkat :',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: _sd,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: "Deskripsi Singkat",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                          fillColor: Colors.grey,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi singkat tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deskripsi :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _des,
                      maxLines: 8,
                      decoration: InputDecoration(
                        labelText: "Deskripsi",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Deskripsi tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Nomor Telephon :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _nt,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Nomor Telephon",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor Telephon tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Email :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _em,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Email",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
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
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Link Market Place :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _lmp,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Link Maket Place",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Link Market Place tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Link Tiktok :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _lti,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Link Tiktok",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Link Tiktok tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Link instagram :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _li,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Link instagram",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Link instagram tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Link facebook :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _lf,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Link facebook",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Link facebook tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Link twitter :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _ltw,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Link twitter",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Link twitter tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Link Pinterest :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _lp,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Link Pinterest",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Link Pinterest tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Link linkedin :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _ll,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Link linkedin",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Link linkedin tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Link Youtube :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _ly,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Link Youtube",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Link Youtube tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Kota Asal :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FutureBuilder(
                    future: RajaOngkir.getCity(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = jsonDecode(snapshot.data!.body)['rajaongkir']
                            ['results'];
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

                              for (int i = 0; i < data.length; i++) {
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
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Alamat :',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _ad,
                      maxLines: 1,

                      decoration: InputDecoration(
                        labelText: "Alamat",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
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
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
