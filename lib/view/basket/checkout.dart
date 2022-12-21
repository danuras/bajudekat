import 'dart:convert';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/product_transaction.dart';
import 'package:baju_dekat/model/transaction.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/auth/enter_email.dart';
import 'package:baju_dekat/view/auth/register.dart';
import 'package:baju_dekat/view/basket/selesai.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/api/product_category_controller.dart';
import 'package:baju_dekat/view_controller/api/product_transaction_controller.dart';
import 'package:baju_dekat/view_controller/api/raja_ongkir.dart';
import 'package:baju_dekat/view_controller/api/transaction_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_category.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class Checkout extends StatefulWidget {
  const Checkout(
      this._auth,
      this._isAuth,
      this._isAdmin,
      this._admin,
      this._gp,
      this._lopc,
      this._info,
      this._user,
      this._city,
      this._totalBerat,
      this._th,
      this._ti,
      {super.key});
  final Auth _auth;
  final bool _isAuth;
  final bool _isAdmin;
  final Admin _admin;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  final Information _info;
  final User _user;
  final String _city;
  final double _totalBerat;
  final double _th;
  final int _ti;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool _isObsecure = true;

  final _formKey = GlobalKey<FormState>();

  var selectedValue;
  var kurir;

  late int cityId, ongkos = -1;

  @override
  void initState() {
    selectedValue = widget._city;
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            const Center(
                              child: Text(
                                "Checkout",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Alamat: ' + widget._user.address),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Kurir (JNE) : '),
                                  Spacer(),
                                  FutureBuilder(
                                    future: RajaOngkir.getCost(
                                        widget._user.city,
                                        int.parse(widget._info.city),
                                        widget._totalBerat),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var data =
                                            jsonDecode(snapshot.data!.body)[
                                                    'rajaongkir']['results'][0]
                                                ['costs'];
                                        print(data.toString());
                                        List<String> items = [];
                                        List<int> costs = [];
                                        for (int i = 0; i < data.length; i++) {
                                          items.add(data[i]['service'] +
                                              '(' +
                                              data[i]['description'] +
                                              ')' +
                                              '\tRp ' +
                                              data[i]['cost'][0]['value']
                                                  .toString());
                                          costs
                                              .add(data[i]['cost'][0]['value']);
                                        }
                                        return CustomDropdownButton2(
                                          buttonWidth: 200,
                                          dropdownWidth: 300,
                                          hint: 'Pilih Kurir',
                                          dropdownItems: items,
                                          value: kurir,
                                          onChanged: (value) {
                                            setState(() {
                                              kurir = value!;
                                              for (int i = 0;
                                                  i < data.length;
                                                  i++) {
                                                if (items[i] == value) {
                                                  ongkos = costs[i];
                                                }
                                              }
                                            });
                                            print(kurir);
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
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          'Rincian Pembayaran',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Total harga Produk: Rp ' +
                                            widget._th.toString(),
                                      ),
                                      Text(
                                        'Biaya Pengiriman: Rp ' +
                                            ((ongkos != -1)
                                                ? ongkos.toString()
                                                : '...'),
                                      ),
                                      Text(
                                        'Total: Rp ' +
                                            ((ongkos != -1)
                                                ? (widget._th + ongkos)
                                                    .toString()
                                                : '...'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TabletButton(
                                action: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (ongkos != -1) {
                                      Transaction transaction =
                                          Transaction.fromJson({
                                        'id': widget._ti,
                                        'cust_id': widget._auth.id,
                                        'address': widget._user.address,
                                        'kurir': kurir,
                                        'total': widget._th,
                                      });
                                      TransactionController tc =
                                          TransactionController();
                                      var response = await tc.updateStatusPesan(
                                          widget._auth, transaction);
                                      var result = jsonDecode(response.body);
                                      if (response.statusCode == 200) {
                                        ProductTransactionController ptc =
                                            ProductTransactionController();
                                        GetCategory _gc = GetCategory(
                                            ProductCategoryController());
                                        List<ProductCategories> _lopc =
                                            await _gc.showAll();
                                        var response =
                                            await ptc.showBasket(widget._auth);
                                        List<Product> lop = [];
                                        List<ProductTransaction> lopt = [];
                                        if (response.statusCode == 200) {
                                          var result =
                                              jsonDecode(response.body);
                                          int length = result['data'].length;
                                          for (int i = 0; i < length; i++) {
                                            lop.add(Product.fromJson({
                                              'image_url': result['data'][i]
                                                  ['image_url'],
                                              'name': result['data'][i]['name'],
                                              'discount': result['data'][i]
                                                  ['discount'],
                                              'discount_expired_at':
                                                  result['data'][i]
                                                      ['discount_expired_at'],
                                            }));
                                            lopt.add(
                                                ProductTransaction.fromJson({
                                              'id': result['data'][i]['id'],
                                              'sell_price': double.parse(
                                                  result['data'][i]
                                                      ['sell_price']),
                                              'currrency': result['data'][i]
                                                  ['currrency'],
                                              'amount': result['data'][i]
                                                  ['amount'],
                                              'product_id': result['data'][i]
                                                  ['product_id'],
                                              'transaction_id': result['data']
                                                  [i]['transaction_id'],
                                              'weight': double.parse(
                                                  result['data'][i]['weight']
                                                      .toString()),
                                            }));
                                          }
                                        }
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: ((context) => Menu(
                                                  Selesai(
                                                    widget._auth,
                                                    widget._admin,
                                                    widget._isAuth,
                                                    widget._isAdmin,
                                                    widget._gp,
                                                    lop,
                                                    lopt,
                                                    widget._lopc,
                                                    widget._info,
                                                    transaction,
                                                    ongkos,
                                                    false,
                                                  ),
                                                  widget._isAuth,
                                                  widget._auth,
                                                  widget._isAdmin,
                                                  widget._admin,
                                                  widget._gp,
                                                  widget._lopc,
                                                  widget._info,
                                                )),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result['message'].toString(),
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result['message'].toString(),
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Kurir belum dipilih',
                                          ),
                                        ),
                                      );
                                    }
                                    /* AuthController _auth = AuthController();
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

                                      List<Product> _lod =
                                          await widget._gp.getDiscount(0);
                                      List<Product> _lop = await widget._gp
                                          .getAllProduct('%%', 0);
                                      int _dl =
                                          await widget._gp.countDiscount();
                                      int _pl =
                                          await widget._gp.countBySearch('%%');

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
                                    } */
                                  }
                                },
                                text: 'Pembayaran',
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
