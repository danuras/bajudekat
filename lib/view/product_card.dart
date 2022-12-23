import 'dart:io';

import 'package:flutter/material.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view/component/admin_detail_product.dart';
import 'package:baju_dekat/view/component/detail_product.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class ProductCard extends StatelessWidget {
  ProductCard(this._admin, this._auth, this._isAdmin, this._isAuth, this._gp,
      this._product, this._lopc, this._info,
      {super.key});
  final bool _isAdmin;
  final Admin _admin;
  final Auth _auth;
  final bool _isAuth;
  final Product _product;
  final List<ProductCategories> _lopc;
  bool _isDiscount = false;
  double newPrice = 0;
  final GetProduct _gp;
  final Information _info;

  @override
  Widget build(BuildContext context) {
    _isDiscount = (_product.discount > 0) &&
        (DateTime.parse(_product.discount_expired_at).isAfter(DateTime.now()));
    if (_isDiscount) {
      newPrice =
          _product.sell_price - _product.sell_price * (_product.discount / 100);
    }
    return Card(
      child: InkWell(
        hoverColor: Colors.transparent,
        onTap: () async {
          Product _p = await _gp.showById(_product.id, _auth.id);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => (_isAdmin)
                  ? AdminDetailProduct(
                      _admin,
                      _isAdmin,
                      _auth,
                      _isAuth,
                      _gp,
                      _p,
                      _lopc,
                      _info,
                    )
                  : DetailProduct(
                      _p,
                      _auth,
                      _admin,
                      _isAuth,
                      _isAdmin,
                      _gp,
                      _info,
                    ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                _product.image_url,
                width: 144,
                height: 144,
              ),
            ),
            Text(_product.name),
            Text(
              'Rp ' + _product.sell_price.toString(),
              style: TextStyle(
                  decoration: (_isDiscount)
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            (_isDiscount)
                ? Text(
                    'Rp ' + newPrice.toString(),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
