import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view/list_product/list_product.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view/navbar.dart';
import 'package:baju_dekat/view/product_card.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class Home extends StatelessWidget {
  Home(
      this.isAuth,
      this.auth,
      this.isAdmin,
      this.admin,
      this._listOfDiscount,
      this._listOfProduct,
      this._gp,
      this._dicountLength,
      this._productLength,
      this._lopc,
      this._info,
      {super.key});
  bool isAuth;
  bool isAdmin;
  Auth auth;
  Admin admin;
  GetProduct _gp;
  List<Product> _listOfDiscount;
  List<Product> _listOfProduct;
  List<ProductCategories> _lopc;
  Information _info;
  int _dicountLength, _productLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: 286,
            width: MediaQuery.of(context).size.width,
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
                          'Discount',
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
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: ((context) => Menu(
                                        ListProduct(
                                          'Discount',
                                          admin,
                                          auth,
                                          isAdmin,
                                          isAuth,
                                          _listOfDiscount,
                                          0,
                                          0,
                                          _dicountLength,
                                          _gp,
                                          _lopc,
                                          _info,
                                        ),
                                        isAuth,
                                        auth,
                                        isAdmin,
                                        admin,
                                        _gp,
                                        _lopc,
                                        _info,
                                      )),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'View All',
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
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: listOfDiscount(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
                          admin,
                          isAdmin,
                          auth,
                          isAuth,
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
                      admin,
                      isAdmin,
                      auth,
                      isAuth,
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
                    'All Product',
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
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: ((context) => Menu(
                                  ListProduct(
                                    'All Product',
                                    admin,
                                    auth,
                                    isAdmin,
                                    isAuth,
                                    _listOfProduct,
                                    _productLength,
                                    0,
                                    0,
                                    _gp,
                                    _lopc,
                                    _info,
                                  ),
                                  isAuth,
                                  auth,
                                  isAdmin,
                                  admin,
                                  _gp,
                                  _lopc,
                                  _info,
                                )),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'View All',
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
          ],
        ),
      ),
    );
  }

  List<Widget> listOfDiscount() {
    List<Widget> list = [];

    for (int i = 0; i < _listOfDiscount.length; i++) {
      list.add(ProductCard(
        admin,
        auth,
        isAdmin,
        isAuth,
        _gp,
        _listOfDiscount[i],
        _lopc,
        _info,
      ));
    }
    return list;
  }

  List<ResponsiveGridCol> listOfProduct() {
    List<ResponsiveGridCol> list = [];
    for (int i = 0; i < _listOfProduct.length; i++) {
      list.add(ResponsiveGridCol(
        xs: 6,
        md: 3,
        child: ProductCard(
          admin,
          auth,
          isAdmin,
          isAuth,
          _gp,
          _listOfProduct[i],
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
