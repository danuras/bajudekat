import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/view/auth/register.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view_controller/api/product_controller.dart';
import 'package:baju_dekat/view_controller/upload_file/pick_image.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct(this._admin, this._product, {super.key});
  final Admin _admin;
  final Product _product;

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final TextEditingController _name = TextEditingController(text: '');
  final TextEditingController _categories_name =
      TextEditingController(text: '');
  final TextEditingController _description = TextEditingController(text: '');
  final TextEditingController _buy_price = TextEditingController(text: '');
  final TextEditingController _sell_price = TextEditingController(text: '');
  final TextEditingController _currency = TextEditingController(text: '');
  final TextEditingController _stock = TextEditingController(text: '');
  final TextEditingController _weight = TextEditingController(text: '');
  final TextEditingController _discount = TextEditingController(text: '0');
  final TextEditingController _discount_expired_at =
      TextEditingController(text: DateTime.now().toString());

  bool _isObsecure = true;
  var _image_url = [
    PlatformFile(
      path: 'assets/default_product.png',
      name: 'none',
      size: 0,
      bytes: Uint8List(0),
    )
  ];
  File _image = File('assets/default_product.png');

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name.text = widget._product.name;
    _categories_name.text = widget._product.categories_name;
    _description.text = widget._product.description;
    _buy_price.text = widget._product.buy_price.toString();
    _sell_price.text = widget._product.sell_price.toString();
    _currency.text = widget._product.currency.toString();
    _stock.text = widget._product.stock.toString();
    _weight.text = widget._product.weight.toString();
    _discount.text = widget._product.discount.toString();
    _discount_expired_at.text = widget._product.discount_expired_at.toString();
    _image = File(widget._product.image_url);
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          children: [
                            const Center(
                              child: Text(
                                "Edit Produk",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            Align(
                              alignment: const Alignment(0, 1),
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  image: (_image_url.first.name == 'none')
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            widget._product.image_url,
                                          ),
                                        )
                                      : DecorationImage(
                                          image: MemoryImage(
                                            _image_url.first.bytes!,
                                          ),
                                        ),
                                  color: Colors.black,
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      _image_url =
                                          (await FilePicker.platform.pickFiles(
                                        allowedExtensions: [
                                          'jpg',
                                          'png',
                                          'jpeg'
                                        ],
                                        allowMultiple: false,
                                        onFileLoading:
                                            (FilePickerStatus status) =>
                                                print(status),
                                        type: FileType.custom,
                                      ))!
                                              .files;
                                    } on PlatformException catch (e) {
                                      print('Unsupported ooperation' +
                                          e.toString());
                                    } catch (e) {
                                      print(e.toString());
                                    }

                                    if (_image_url != null) {
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _name,
                              decoration: InputDecoration(
                                labelText: "Nama",
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
                              controller: _categories_name,
                              decoration: InputDecoration(
                                labelText: "Kategori",
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kategori tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              child: TextFormField(
                                controller: _description,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  labelText: "Deskripsi Produk",
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.grey,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Deskripsi produk tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            TextFormField(
                              controller: _buy_price,
                              inputFormatters: <TextInputFormatter>[
                                // for below version 2 use this
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Harga Beli",
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kategori tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _sell_price,
                              inputFormatters: <TextInputFormatter>[
                                // for below version 2 use this
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Harga Jual",
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harga jual tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _currency,
                              decoration: InputDecoration(
                                labelText: "Mata Uang",
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mata Uang tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _stock,
                              inputFormatters: <TextInputFormatter>[
                                // for below version 2 use this
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Stok",
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Stok tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _weight,
                              decoration: InputDecoration(
                                labelText: "Berat",
                                fillColor: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Berat tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            TextField(
                              controller: _discount,
                              inputFormatters: <TextInputFormatter>[
                                // for below version 2 use this
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Diskon",
                                fillColor: Colors.grey,
                              ),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons
                                      .calendar_today), //icon of text field
                                  labelText:
                                      "Diskon Berakhir Pada" //label text of field
                                  ),
                              readOnly: true,
                              controller: _discount_expired_at,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(
                                        1900), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  //you can implement different kind of Date Format here according to your requirement

                                  setState(() {
                                    _discount_expired_at.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              }, // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Tanggal tidak boleh kosong';
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
                                      Product _product = Product.fromJson({
                                        'name': _name.text,
                                        'categories_name':
                                            _categories_name.text,
                                        'description': _description.text,
                                        'buy_price': _buy_price.text,
                                        'sell_price': _sell_price.text,
                                        'currency': _currency.text,
                                        'stock': _stock.text,
                                        'weight': _weight.text,
                                        'discount': _discount.text,
                                        'discount_expired_at':
                                            _discount_expired_at.text,
                                      });
                                      ProductController _pc =
                                          ProductController();

                                      print('lol');
                                      var response = await _pc.update(
                                        widget._admin,
                                        _product,
                                        widget._product.id,
                                        _image_url.first.bytes!,
                                        _image_url.first.name,
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

                                        Navigator.of(context).pop();
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
