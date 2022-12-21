import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/product_transaction.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/auth/enter_code.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/api/product_category_controller.dart';
import 'package:baju_dekat/view_controller/api/product_transaction_controller.dart';
import 'package:baju_dekat/view_controller/api/user_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_category.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class DetailProduct extends StatefulWidget {
  DetailProduct(this._product, this.auth, this.admin, this._isAuth,
      this._isAdmin, this._gp, this._info,
      {super.key});
  final Product _product;
  final Auth auth;
  final bool _isAuth;
  final Admin admin;
  final bool _isAdmin;
  final GetProduct _gp;
  final Information _info;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  int amount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdddddd),
      appBar: AppBar(
        title: Text(widget._product.name),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 50,
            maxWidth: 1000,
          ),
          child: Card(
            child: ListView(
              children: [
                (MediaQuery.of(context).size.width > 560)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Image.network(
                              widget._product.image_url,
                              width: 250,
                              height: 250,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget._product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'stok: ' + widget._product.stock.toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget._product.sell_price.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  (widget._product.sell_price -
                                          widget._product.discount *
                                              widget._product.sell_price /
                                              100)
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'berat: ' + widget._product.weight.toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 80),
                                (!widget._product.isBasket)
                                    ? Align(
                                        alignment: Alignment(0.8, 1),
                                        child: TabletButton(
                                          action: () async {
                                            ProductTransactionController ptc =
                                                ProductTransactionController();
                                            ProductTransaction
                                                productTransaction =
                                                ProductTransaction.fromJson({
                                              'buy_price':
                                                  widget._product.buy_price,
                                              'sell_price':
                                                  widget._product.sell_price,
                                              'currency':
                                                  widget._product.currency,
                                              'weight': widget._product.weight,
                                              'amount': amount,
                                              'product_id': widget._product.id,
                                            });

                                            var response = await ptc.create(
                                                widget.auth,
                                                productTransaction);
                                            if (response.statusCode == 200) {
                                              Navigator.of(context).pop();
                                            } else if (response.statusCode ==
                                                350) {
                                              UserController uc =
                                                  UserController();
                                              var response =
                                                  await uc.show(widget.auth);

                                              var result =
                                                  jsonDecode(response.body);
                                              User user =
                                                  User.fromJson(result['data']);

                                              GetCategory _gc = GetCategory(
                                                  ProductCategoryController());
                                              List<ProductCategories> _lopc =
                                                  await _gc.showAll();
                                              if (!mounted) {
                                                return;
                                              }
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  opaque: false,
                                                  pageBuilder:
                                                      (context, __, ___) =>
                                                          EnterCode(
                                                    user.email,
                                                    widget.auth,
                                                    widget._isAdmin,
                                                    widget.admin,
                                                    widget._gp,
                                                    _lopc,
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

                                              GetCategory _gc = GetCategory(
                                                  ProductCategoryController());
                                              List<ProductCategories> _lopc =
                                                  await _gc.showAll();
                                              AuthController au =
                                                  AuthController();
                                              au.isAuth(
                                                widget._isAuth,
                                                widget.auth,
                                                context,
                                                widget._isAdmin,
                                                widget.admin,
                                                widget._gp,
                                                _lopc,
                                                widget._info,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      result['message']
                                                          .toString()),
                                                ),
                                              );
                                            }
                                          },
                                          text: 'Keranjang+',
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment(0.8, 1),
                                        child: Container(
                                          width: 200,
                                          height: 40,
                                          color: Colors.green,
                                          child: Center(
                                            child: Text(
                                              'Dikeranjang',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                (!widget._product.isBasket)
                                    ? Align(
                                        alignment: Alignment(0.8, 1),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Jumlah: '),
                                            TextButton(
                                              onPressed: () {
                                                if (amount > 1) {
                                                  amount--;
                                                  setState(() {});
                                                }
                                              },
                                              child: Text('-'),
                                            ),
                                            Text(
                                              amount.toString(),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (amount <
                                                    widget._product.stock) {
                                                  amount++;
                                                  setState(() {});
                                                }
                                              },
                                              child: Text('+'),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Image.network(
                              widget._product.image_url,
                              width: 250,
                              height: 250,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget._product.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'stok: ' + widget._product.stock.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget._product.sell_price.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            (widget._product.sell_price -
                                    widget._product.discount *
                                        widget._product.sell_price)
                                .toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'berat: ' + widget._product.weight.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 80),
                          Align(
                            alignment: Alignment.center,
                            child: TabletButton(
                              action: () async {
                                ProductTransactionController ptc =
                                    ProductTransactionController();
                                ProductTransaction productTransaction =
                                    ProductTransaction.fromJson({
                                  'buy_price': widget._product.buy_price,
                                  'sell_price': widget._product.sell_price,
                                  'currency': widget._product.currency,
                                  'amount': amount,
                                  'product_id': widget._product.id,
                                });

                                var response = await ptc.create(
                                    widget.auth, productTransaction);
                                if (response.statusCode == 200) {
                                  Navigator.of(context).pop();
                                } else if (response.statusCode == 350) {
                                  UserController uc = UserController();
                                  var response = await uc.show(widget.auth);

                                  var result = jsonDecode(response.body);
                                  User user = User.fromJson(result['data']);

                                  GetCategory _gc =
                                      GetCategory(ProductCategoryController());
                                  List<ProductCategories> _lopc =
                                      await _gc.showAll();
                                  if (!mounted) {
                                    return;
                                  }
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (context, __, ___) =>
                                          EnterCode(
                                        user.email,
                                        widget.auth,
                                        widget._isAdmin,
                                        widget.admin,
                                        widget._gp,
                                        _lopc,
                                        widget._info,
                                      ),
                                    ),
                                  );
                                } else {
                                  if (!mounted) {
                                    return;
                                  }
                                  var result = jsonDecode(response.body);

                                  GetCategory _gc =
                                      GetCategory(ProductCategoryController());
                                  List<ProductCategories> _lopc =
                                      await _gc.showAll();
                                  AuthController au = AuthController();
                                  au.isAuth(
                                    widget._isAuth,
                                    widget.auth,
                                    context,
                                    widget._isAdmin,
                                    widget.admin,
                                    widget._gp,
                                    _lopc,
                                    widget._info,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text(result['message'].toString()),
                                    ),
                                  );
                                }
                              },
                              text: 'Keranjang+',
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Jumlah: '),
                                TextButton(
                                  onPressed: () {
                                    if (amount > 1) {
                                      amount--;
                                      setState(() {});
                                    }
                                  },
                                  child: Text('-'),
                                ),
                                Text(
                                  amount.toString(),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (amount < widget._product.stock) {
                                      amount++;
                                      setState(() {});
                                    }
                                  },
                                  child: Text('+'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 30),
                Divider(),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      widget._product.description,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
