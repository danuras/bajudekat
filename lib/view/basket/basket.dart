import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/product_transaction.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/basket/checkout.dart';
import 'package:baju_dekat/view/basket/product_banner.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view_controller/api/raja_ongkir.dart';
import 'package:baju_dekat/view_controller/api/user_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class Basket extends StatelessWidget {
  const Basket(this._auth, this._isAuth, this._isAdmin, this._admin, this._gp,
      this._lopc, this._lop, this._lopt, this._info,
      {super.key});

  final Auth _auth;
  final bool _isAdmin, _isAuth;
  final Admin _admin;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  final List<Product> _lop;
  final List<ProductTransaction> _lopt;
  final Information _info;

  double totalHarga() {
    double totalHarga = 0;
    for (int i = 0; i < _lopt.length; i++) {
      try {
        if (DateTime.parse(_lop[i].discount_expired_at)
            .isAfter(DateTime.now())) {
          totalHarga += (_lopt[i].sell_price -
                  _lopt[i].sell_price * _lop[i].discount / 100) *
              _lopt[i].amount;
        } else {
          totalHarga += _lopt[i].sell_price * _lopt[i].amount;
        }
      } catch (e) {
        totalHarga += _lopt[i].sell_price * _lopt[i].amount;
      }
    }
    return totalHarga;
  }

  double totalBerat() {
    double total = 1;
    for (int i = 0; i < _lopt.length; i++) {
      total += _lop[i].weight * _lopt[i].amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: const Color(0xff8d9de8),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 50,
            maxWidth: 1000,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: [
                ResponsiveGridRow(
                  children: listOfProduct(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          children: [
            Spacer(),
            Text('Total: ' + totalHarga().toString()),
            SizedBox(
              width: 80,
            ),
            Container(
              width: 150,
              color: Colors.blue,
              height: double.infinity,
              child: Container(
                color: const Color(0xff737fb3),
                child: InkWell(
                  onTap: () async {
                    if (_lop.length > 0) {
                      UserController uc = UserController();
                      var response = await uc.show(_auth);
                      if (response.statusCode == 200) {
                        var result = jsonDecode(response.body);
                        User user = User.fromJson(result['data'][0]);

                        var rcity = await RajaOngkir.getCityById(
                          user.city,
                        );
                        var resultcity = jsonDecode(rcity.body);
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, __, ___) {
                              return Checkout(
                                _auth,
                                _isAuth,
                                _isAdmin,
                                _admin,
                                _gp,
                                _lopc,
                                _info,
                                user,
                                resultcity['rajaongkir']['results']
                                    ['city_name'],
                                totalBerat(),
                                totalHarga(),
                                _lopt[0].transaction_id,
                              );
                            },
                          ),
                        );
                      } else {
                        var result = jsonDecode(response.body);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result['message'].toString()),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Belum ada barang dikeranjang!'),
                        ),
                      );
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ResponsiveGridCol> listOfProduct() {
    List<ResponsiveGridCol> list = [];
    for (int i = 0; i < _lop.length; i++) {
      list.add(ResponsiveGridCol(
        xs: 12,
        md: 6,
        child: ProductBanner(
          _auth,
          _admin,
          _isAuth,
          _isAdmin,
          _gp,
          _lop[i],
          _lopt[i],
          _info,
          true,
        ),
      ));
    }
    return list;
  }
}
