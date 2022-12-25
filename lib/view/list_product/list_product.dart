import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view/navbar.dart';
import 'package:baju_dekat/view/product_card.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class ListProduct extends StatelessWidget {
  ListProduct(
      this.title,
      this._admin,
      this._auth,
      this._isAdmin,
      this._isAuth,
      this._lop,
      this._lol,
      this.count,
      this.pi,
      this._gp,
      this._lopc,
      this._info,
      {super.key});
  final String title;
  final Admin _admin;
  final Auth _auth;
  final bool _isAdmin;
  final bool _isAuth;

  final List<Product> _lop;
  int _lol, count, pi;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  final Information _info;

  @override
  Widget build(BuildContext context) {
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
                  (count > 0)
                      ? Container(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                if (count > 0) {
                                  List<Product> _lopn;
                                  if (title == 'All Product') {
                                    count -= 24;
                                    _lopn =
                                        await _gp.getAllProduct('%%', count);
                                  } else if (title == 'Discount') {
                                    count -= 24;
                                    _lopn = await _gp.getDiscount(count);
                                  } else {
                                    count -= 24;
                                    _lopn =
                                        await _gp.getAllByCategory(pi, count);
                                  }
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: ((context) => Menu(
                                            ListProduct(
                                              title,
                                              _admin,
                                              _auth,
                                              _isAdmin,
                                              _isAuth,
                                              _lopn,
                                              _lol,
                                              count,
                                              pi,
                                              _gp,
                                              _lopc,
                                              _info,
                                            ),
                                            _isAuth,
                                            _auth,
                                            _isAdmin,
                                            _admin,
                                            _gp,
                                            _lopc,
                                            _info,
                                          )),
                                    ),
                                  );
                                }
                              },
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
                  ((count + 24) < _lol)
                      ? Container(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                if ((count + 24) < _lol) {
                                  List<Product> _lopn;
                                  if (title == 'All Product') {
                                    count += 24;
                                    _lopn =
                                        await _gp.getAllProduct('%%', count);
                                  } else if (title == 'Discount') {
                                    count += 24;
                                    _lopn = await _gp.getDiscount(count);
                                  } else {
                                    count += 24;
                                    _lopn =
                                        await _gp.getAllByCategory(pi, count);
                                  }
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: ((context) => Menu(
                                            ListProduct(
                                              title,
                                              _admin,
                                              _auth,
                                              _isAdmin,
                                              _isAuth,
                                              _lopn,
                                              _lol,
                                              count,
                                              pi,
                                              _gp,
                                              _lopc,
                                              _info,
                                            ),
                                            _isAuth,
                                            _auth,
                                            _isAdmin,
                                            _admin,
                                            _gp,
                                            _lopc,
                                            _info,
                                          )),
                                    ),
                                  );
                                }
                              },
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
