import 'dart:convert';

import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view_controller/api/product_category_controller.dart';
import 'package:baju_dekat/view_controller/api/product_controller.dart';

class GetProduct {
  GetProduct(this._pc, this._pcc);
  final ProductController _pc;
  final ProductCategoryController _pcc;

  Future<int> countDiscount() async {
    try {
      var response = await _pc.countDiscount();
      var result = jsonDecode(response.body);
      return int.parse(result['data'][0]['count'].toString());
    } catch (e) {
      return 0;
    }
  }

  Future<List<Product>> getDiscount(int count) async {
    List<Product> _lod = [];

    try {
      var responsed = await _pc.showAllDiscount(count);
      var resultd = jsonDecode(responsed.body);
      int k = 0;

      if (responsed.statusCode == 200) {
        if (resultd['data'].length < 10) {
          k = resultd['data'].length;
        } else {
          k = 10;
        }

        for (int i = 0; i < k; i++) {
          _lod.add(
            Product.fromJson(
              {
                'id': resultd['data'][i]['id'],
                'name': resultd['data'][i]['name'],
                'image_url': resultd['data'][i]['image_url'],
                'categories_name': jsonDecode((await _pcc.showById(
                  resultd['data'][i]['categories_id'],
                ))
                    .body)['data'][0]['categories_name'],
                'sell_price': resultd['data'][i]['sell_price'],
                'currency': resultd['data'][i]['currency'],
                'discount': resultd['data'][i]['discount'],
                'discount_expired_at': resultd['data'][i]
                    ['discount_expired_at'],
                'isBasket': resultd['data'][i]['isBasket'],
              },
            ),
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return _lod;
  }

  Future<int> countBySearch(String search) async {
    try {
      var response = await _pc.countBySearch(search);
      var result = jsonDecode(response.body);
      return int.parse(result['data'][0]['count'].toString());
    } catch (e) {
      return 0;
    }
  }

  Future<List<Product>> getAllProduct(String search, int count) async {
    List<Product> _lop = [];
    try {
      var responsep = await _pc.showBySearch(search, count);
      var resultp = jsonDecode(responsep.body);
      int k = 0;
      if (responsep.statusCode == 200) {
        if (resultp['data'].length < 24) {
          k = resultp['data'].length;
        } else {
          k = 24;
        }
        for (int i = 0; i < k; i++) {
          _lop.add(
            Product.fromJson(
              {
                'id': resultp['data'][i]['id'],
                'name': resultp['data'][i]['name'],
                'image_url': resultp['data'][i]['image_url'],
                'categories_name': jsonDecode((await _pcc.showById(
                  resultp['data'][i]['categories_id'],
                ))
                    .body)['data'][0]['categories_name'],
                'sell_price': resultp['data'][i]['sell_price'],
                'currency': resultp['data'][i]['currency'],
                'discount': resultp['data'][i]['discount'],
                'discount_expired_at': resultp['data'][i]
                    ['discount_expired_at'],
                'isBasket': resultp['data'][i]['isBasket'],
              },
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
    return _lop;
  }

  Future<int> countByCategory(int categories_id) async {
    try {
      var response = await _pc.countByCategory(categories_id);
      var result = jsonDecode(response.body);
      return int.parse(result['data'][0]['count'].toString());
    } catch (e) {
      return 0;
    }
  }

  Future<List<Product>> getAllByCategory(int categories_id, int count) async {
    List<Product> _lop = [];
    try {
      var responsep = await _pc.showAllByCategory(categories_id, count);
      var resultp = jsonDecode(responsep.body);
      int k = 0;
      if (responsep.statusCode == 200) {
        if (resultp['data'].length < 24) {
          k = resultp['data'].length;
        } else {
          k = 24;
        }
        for (int i = 0; i < k; i++) {
          _lop.add(
            Product.fromJson(
              {
                'id': resultp['data'][i]['id'],
                'name': resultp['data'][i]['name'],
                'image_url': resultp['data'][i]['image_url'],
                'categories_name': jsonDecode((await _pcc.showById(
                  resultp['data'][i]['categories_id'],
                ))
                    .body)['data'][0]['categories_name'],
                'sell_price': resultp['data'][i]['sell_price'],
                'currency': resultp['data'][i]['currency'],
                'discount': resultp['data'][i]['discount'],
                'discount_expired_at': resultp['data'][i]
                    ['discount_expired_at'],
                'isBasket': resultp['data'][i]['isBasket'],
              },
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
    return _lop;
  }

  Future<Product> showById(int product_id, int cust_id) async {
    Product product;
    print(cust_id);
    var response = await _pc.showById(product_id, cust_id);
    var result = jsonDecode(response.body);
    product = Product.fromJson({
      'id': result['data'][0]['id'],
      'name': result['data'][0]['name'],
      'image_url': result['data'][0]['image_url'],
      'categories_name': jsonDecode((await _pcc.showById(
        result['data'][0]['categories_id'],
      ))
          .body)['data'][0]['categories_name'],
      'description': result['data'][0]['description'],
      'buy_price': result['data'][0]['buy_price'],
      'sell_price': result['data'][0]['sell_price'],
      'currency': result['data'][0]['currency'],
      'weight': result['data'][0]['weight'],
      'stock': result['data'][0]['stock'],
      'isBasket': result['data'][0]['isBasket'],
      'discount': result['data'][0]['discount'],
      'discount_expired_at': result['data'][0]['discount_expired_at'],
    });
    return product;
  }
}
