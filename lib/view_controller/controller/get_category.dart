import 'dart:convert';

import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/view_controller/api/product_category_controller.dart';

class GetCategory {
  ProductCategoryController _pcc;
  GetCategory(this._pcc);
  Future<List<ProductCategories>> showAll() async {
    List<ProductCategories> lopc = [];
    try {
      var response = await _pcc.showAll();
      var result = jsonDecode(response.body);
      int k = 0;
      if (response.statusCode == 200) {
        if (result['data'].length < 10) {
          k = result['data'].length;
        } else {
          k = 10;
        }
        for (int i = 0; i < k; i++) {
          lopc.add(
            ProductCategories.fromJson(
              {
                'id': result['data'][i]['id'],
                'name': result['data'][i]['categories_name'],
              },
            ),
          );
        }
      } else {
        print(result['message'].toString());
      }
    } catch (e) {
      print(e.toString());
    }
    return lopc;
  }
}
