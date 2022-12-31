import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view/list_product/list_product.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class NavBar extends StatelessWidget {
  NavBar(this._loc, this._admin, this._isAdmin, this._auth, this._isAuth,
      this._gp, this._info,
      {super.key});
  final List<ProductCategories> _loc;
  final Admin _admin;
  final bool _isAdmin;
  final Auth _auth;
  final bool _isAuth;
  final GetProduct _gp;
  final Information _info;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          height: 60,
          child: Card(
            elevation: 3.0,
            child: Material(
              color: Color(0xff42b549),
              child: Center(
                child: Text(
                  'Tokopedia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            width: double.maxFinite,
            child: Card(
              elevation: 3.0,
              child: Material(
                child: Center(
                  child: ResponsiveGridRow(
                    children: [
                          ResponsiveGridCol(
                            lg: 12,
                            child: Container(
                              height: 60,
                              alignment: Alignment(0, 0),
                              color: Colors.purple,
                              child: const Material(
                                color: Color(0xff8d9de8),
                                child: Center(
                                  child: Text(
                                    'Media Sosial',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ] +
                        listOfSocialMedia(),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            width: double.maxFinite,
            child: Card(
              elevation: 3.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        const Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        SizedBox(),
                      ] +
                      listOfCategory(context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<ResponsiveGridCol> listOfSocialMedia() {
    List<ResponsiveGridCol> list = [
      ResponsiveGridCol(
        xs: 6,
        md: 3,
        child: buildSocialIcon(
          FontAwesomeIcons.tiktok,
          () {},
        ),
      ),
      ResponsiveGridCol(
        xs: 6,
        md: 3,
        child: buildSocialIcon(
          FontAwesomeIcons.instagram,
          () {},
        ),
      ),
      ResponsiveGridCol(
        xs: 6,
        md: 3,
        child: buildSocialIcon(
          FontAwesomeIcons.facebook,
          () {},
        ),
      ),
      ResponsiveGridCol(
        xs: 6,
        md: 3,
        child: buildSocialIcon(
          FontAwesomeIcons.twitter,
          () {},
        ),
      ),
      ResponsiveGridCol(
        xs: 6,
        md: 3,
        child: buildSocialIcon(
          FontAwesomeIcons.pinterest,
          () {},
        ),
      ),
      ResponsiveGridCol(
        xs: 6,
        md: 3,
        child: buildSocialIcon(
          FontAwesomeIcons.linkedin,
          () {},
        ),
      ),
      ResponsiveGridCol(
        xs: 6,
        md: 3,
        child: buildSocialIcon(
          FontAwesomeIcons.youtube,
          () {},
        ),
      )
    ];
    return list;
  }

  List<Widget> listOfCategory(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < _loc.length; i++) {
      list.add(TextButton(
        child: Text(_loc[i].name),
        onPressed: () async {
          List<Product> _listOfProduct =
              await _gp.getAllByCategory(_loc[i].id, 0);
          int _productLength = await _gp.countByCategory(_loc[i].id);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: ((context) => Menu(
                    ListProduct(
                      _loc[i].name,
                      _admin,
                      _auth,
                      _isAdmin,
                      _isAuth,
                      _listOfProduct,
                      _productLength,
                      0,
                      _loc[i].id,
                      _gp,
                      _loc,
                      _info,
                    ),
                    _isAuth,
                    _auth,
                    _isAdmin,
                    _admin,
                    _gp,
                    _loc,
                    _info,
                  )),
            ),
          );
        },
      ));
    }
    return list;
  }

  Widget buildSocialIcon(IconData icon, VoidCallback action) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue,
          child: Material(
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                action();
              },
              child: Center(
                child: Icon(icon, size: 32, color: Colors.white),
              ),
            ),
          ),
        ),
      );
}
