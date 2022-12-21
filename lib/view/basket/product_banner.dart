import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/product_transaction.dart';
import 'package:baju_dekat/view/basket/basket.dart';
import 'package:baju_dekat/view/component/detail_product.dart';
import 'package:baju_dekat/view_controller/api/product_category_controller.dart';
import 'package:baju_dekat/view_controller/api/product_transaction_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_category.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class ProductBanner extends StatelessWidget {
  ProductBanner(this._auth, this._admin, this._isAuth, this._isAdmin, this._gp,
      this._product, this._pt, this._info, this._isDisable,
      {super.key});
  Product _product;
  Auth _auth;
  Admin _admin;
  bool _isAuth;
  bool _isAdmin;
  GetProduct _gp;
  ProductTransaction _pt;
  bool isD = false;
  Information _info;
  bool _isDisable = false;

  @override
  Widget build(BuildContext context) {
    isD = (_product.discount > 0) &&
        (DateTime.parse(_product.discount_expired_at).isAfter(DateTime.now()));
    return Card(
      child: InkWell(
        hoverColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                _product.image_url,
                width: 100,
                height: 100,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _product.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Rp ' + _pt.sell_price.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        decoration: (isD)
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    (isD)
                        ? Text(
                            'Rp ' +
                                (_pt.sell_price -
                                        _pt.sell_price *
                                            _product.discount /
                                            100)
                                    .toString(),
                            overflow: TextOverflow.ellipsis,
                          )
                        : SizedBox(),
                    Text(
                      'jumlah: ' + _pt.amount.toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              (_isDisable)
                  ? Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Center(
                        child: InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          onTap: () async {
                            ProductTransactionController ptc =
                                ProductTransactionController();
                            var response = await ptc.delete(_auth, _pt.id);
                            if (response.statusCode == 200) {
                              var result = jsonDecode(response.body);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result['message'].toString()),
                                ),
                              );

                              ProductTransactionController ptc =
                                  ProductTransactionController();
                              GetCategory _gc =
                                  GetCategory(ProductCategoryController());
                              List<ProductCategories> _lopc =
                                  await _gc.showAll();
                              var respon = await ptc.showBasket(_auth);
                              List<Product> lop = [];
                              List<ProductTransaction> lopt = [];
                              if (respon.statusCode == 200) {
                                var result = jsonDecode(respon.body);
                                int length = result['data'].length;
                                for (int i = 0; i < length; i++) {
                                  lop.add(Product.fromJson({
                                    'image_url': result['data'][i]['image_url'],
                                    'name': result['data'][i]['name'],
                                    'discount': result['data'][i]['discount'],
                                    'discount_expired_at': result['data'][i]
                                        ['discount_expired_at'],
                                  }));
                                  lopt.add(ProductTransaction.fromJson({
                                    'id': result['data'][i]['id'],
                                    'sell_price': double.parse(
                                        result['data'][i]['sell_price']),
                                    'currrency': result['data'][i]['currrency'],
                                    'amount': result['data'][i]['amount'],
                                    'product_id': result['data'][i]
                                        ['product_id'],
                                    'transaction_id': result['data'][i]
                                        ['transaction_id'],
                                    'weight': double.parse(
                                        result['data'][i]['weight'].toString()),
                                  }));
                                }
                              }
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Basket(
                                    _auth,
                                    _isAuth,
                                    _isAdmin,
                                    _admin,
                                    _gp,
                                    _lopc,
                                    lop,
                                    lopt,
                                    _info,
                                  ),
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
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
