import 'package:flutter/material.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view/list_product/list_product.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class SearchBar extends StatelessWidget {
  SearchBar(this._searchController, this._admin, this._auth, this._isAdmin,
      this._isAuth, this._gp, this._lopc, this._info,
      {super.key});
  final _searchController;
  final Admin _admin;
  final Auth _auth;
  final bool _isAdmin;
  final bool _isAuth;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  final Information _info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: TextField(
            onSubmitted: (value) async {
              List<Product> _lop = await _gp.getAllProduct(
                  '%' + _searchController.text + '%', 0);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: ((context) => Menu(
                        ListProduct(
                          'Hasil: ' + _searchController.text,
                          _admin,
                          _auth,
                          _isAdmin,
                          _isAuth,
                          _lop,
                          _lop.length,
                          0,
                          0,
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
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              fillColor: Colors.white,
              hintText: "Search",
              hintStyle: TextStyle(fontSize: 14),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              filled: true,
            ),
            controller: _searchController,
          ),
        ),
      ),
    );
  }
}
