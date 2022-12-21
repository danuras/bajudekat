import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view/admin/components/add_product.dart';
import 'package:baju_dekat/view/navbar.dart';
import 'package:baju_dekat/view/product_card.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class MenejemenProduct extends StatelessWidget {
  MenejemenProduct(
      this.title,
      this._admin,
      this._isAdmin,
      this._auth,
      this._isAuth,
      this._gp,
      this._lop,
      this._lol,
      this.count,
      this._lopc,
      this._info,
      {super.key});
  String title;
  Admin _admin;
  bool _isAdmin;
  Auth _auth;
  bool _isAuth;
  GetProduct _gp;
  List<Product> _lop;
  int _lol;
  int count;
  List<ProductCategories> _lopc;
  Information _info;

  @override
  Widget build(BuildContext context) {
    print('MP: ' + _admin.id.toString());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: (MediaQuery.of(context).size.width > 900)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: buildBody(context),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: NavBar(
                          _lopc,
                          _admin,
                          _isAdmin,
                          _auth,
                          _isAuth,
                          _gp,
                          _info,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    buildBody(context),
                    NavBar(
                      _lopc,
                      _admin,
                      _isAdmin,
                      _auth,
                      _isAuth,
                      _gp,
                      _info,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    return SizedBox(
      width: double.infinity * 2 / 3,
      child: Card(
        elevation: 3.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 8.0,
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'cursive',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Material(
                    color: Colors.green,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, __, ___) {
                              return AddProduct(
                                _admin,
                                _isAdmin,
                                _auth,
                                _isAuth,
                                _gp,
                                _lopc,
                                _info,
                              );
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Tambah Produk',
                          style: TextStyle(
                            fontFamily: 'cursive',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            ResponsiveGridRow(
              children: listOfProduct(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (count != 0)
                      ? Container(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                'Sebelumnya',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Sebelumnya',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                  SizedBox(width: 40),
                  ((count + 1) * 24 < _lol)
                      ? Container(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                'Selanjutnya',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Selanjutnya',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                ],
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
        xs: 6,
        md: 3,
        child: ProductCard(
          _admin,
          _auth,
          _isAdmin,
          _isAuth,
          _gp,
          _lop[i],
          _lopc,
          _info,
        ),
      ));
    }
    return list;
  }

  Widget buildSocialIcon(IconData icon) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue,
          child: Material(
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Center(
                child: Icon(icon, size: 32, color: Colors.white),
              ),
            ),
          ),
        ),
      );
}
