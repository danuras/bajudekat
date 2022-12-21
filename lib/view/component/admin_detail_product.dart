import 'dart:io';

import 'package:flutter/material.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view/admin/components/update_product.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view_controller/api/product_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class AdminDetailProduct extends StatelessWidget {
  AdminDetailProduct(this.admin, this._isAdmin, this._auth, this._isAuth,
      this._gp, this._product, this._lopc, this._info,
      {super.key});
  final Admin admin;
  final bool _isAdmin;
  final Auth _auth;
  final bool _isAuth;
  final GetProduct _gp;
  final Product _product;
  final List<ProductCategories> _lopc;
  final Information _info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdddddd),
      appBar: AppBar(
        title: Text(_product.name),
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
                              _product.image_url,
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
                                  _product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'stok: ' + _product.stock.toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Rp ' + _product.sell_price.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  'Rp ' +
                                      (_product.sell_price -
                                              (_product.discount *
                                                  _product.sell_price /
                                                  100))
                                          .toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'berat: ' +
                                      _product.weight.toString() +
                                      ' gram',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 80),
                                Align(
                                  alignment: Alignment(0.8, 1),
                                  child: TabletButton(
                                    action: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Hapus'),
                                        content: const Text(
                                            'Apakah anda yakin ingin menghapus produk'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'Tidak'),
                                            child: const Text('Tidak'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              ProductController pc =
                                                  ProductController();
                                              await pc.delete(
                                                  admin, _product.id);

                                              List<Product> _lod =
                                                  await _gp.getDiscount(0);
                                              List<Product> _lop = await _gp
                                                  .getAllProduct('%%', 0);
                                              int _dl =
                                                  await _gp.countDiscount();
                                              int _pl =
                                                  await _gp.countBySearch('%%');
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Menu(
                                                    Home(
                                                      _isAuth,
                                                      _auth,
                                                      _isAdmin,
                                                      admin,
                                                      _lod,
                                                      _lop,
                                                      _gp,
                                                      _dl,
                                                      _pl,
                                                      _lopc,
                                                      _info,
                                                    ),
                                                    false,
                                                    _auth,
                                                    _isAdmin,
                                                    admin,
                                                    _gp,
                                                    _lopc,
                                                    _info,
                                                  ),
                                                ),
                                                ModalRoute.withName('/'),
                                              );
                                            },
                                            child: const Text('Ya'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    text: 'Hapus',
                                  ),
                                ),
                                SizedBox(height: 20),
                                Align(
                                  alignment: Alignment(0.8, 1),
                                  child: TabletButton(
                                    action: () => Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (context, __, ___) {
                                          return UpdateProduct(admin, _product);
                                        },
                                      ),
                                    ),
                                    text: 'Edit',
                                  ),
                                ),
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
                              _product.image_url,
                              width: 250,
                              height: 250,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            _product.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'stok: ' + _product.stock.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _product.sell_price.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            (_product.sell_price -
                                    _product.discount * _product.sell_price)
                                .toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'berat: ' + _product.weight.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 80),
                          Align(
                            alignment: Alignment.center,
                            child: TabletButton(
                              action: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Hapus'),
                                  content: const Text(
                                      'Apakah anda yakin ingin menghapus produk'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Tidak'),
                                      child: const Text('Tidak'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        ProductController pc =
                                            ProductController();
                                        await pc.delete(admin, 2);

                                        Navigator.pop(context, 'Ya');
                                      },
                                      child: const Text('Ya'),
                                    ),
                                  ],
                                ),
                              ),
                              text: 'Hapus',
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: TabletButton(
                              action: () => Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (context, __, ___) {
                                    return UpdateProduct(admin, _product);
                                  },
                                ),
                              ),
                              text: 'Edit',
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
                      _product.description,
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
