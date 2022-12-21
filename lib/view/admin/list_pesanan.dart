import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/product_transaction.dart';
import 'package:baju_dekat/model/transaction.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/basket/selesai.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view/navbar.dart';
import 'package:baju_dekat/view_controller/api/product_category_controller.dart';
import 'package:baju_dekat/view_controller/api/product_transaction_controller.dart';
import 'package:baju_dekat/view_controller/api/transaction_controller.dart';
import 'package:baju_dekat/view_controller/api/user_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_category.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class ListPesanan extends StatefulWidget {
  ListPesanan(this._admin, this._isAdmin, this._auth, this._isAuth, this._gp,
      this._lopc, this._info);
  final Admin _admin;
  final bool _isAdmin;
  final Auth _auth;
  final bool _isAuth;
  final GetProduct _gp;
  final List<ProductCategories> _lopc;
  final Information _info;

  @override
  State<ListPesanan> createState() => _ListPesananState();
}

class _ListPesananState extends State<ListPesanan> {
  final double coverHeight = 280, profileHeight = 144;
  late User _user;
  late UserController _userController;
  late Future<http.Response> _bar;
  final List<String> items = [
    'Belum diproses',
    'Diterima penjual',
  ];
  String selectedValue = 'Belum diproses';
  int status = 1;
  TransactionController tc = TransactionController();

  @override
  void initState() {
    _userController = UserController();
    super.initState();
    //_bar = _userController.show(widget.auth);
  }

  void _retry() {
    setState(() {
      //_bar = _userController.show(widget.auth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: (MediaQuery.of(context).size.width > 900)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: buildContent(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: NavBar(
                      widget._lopc,
                      widget._admin,
                      widget._isAdmin,
                      widget._auth,
                      widget._isAuth,
                      widget._gp,
                      widget._info,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                buildContent(),
                NavBar(
                  widget._lopc,
                  widget._admin,
                  widget._isAdmin,
                  widget._auth,
                  widget._isAuth,
                  widget._gp,
                  widget._info,
                ),
              ],
            ),
    );
  }

  Widget buildContent() => SizedBox(
        width: double.infinity * 2 / 3,
        child: Card(
          elevation: 3.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 8),
              Text(
                'History',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 48.0),
                child: Row(
                  children: [
                    Text('Status'),
                    SizedBox(
                      width: 80,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;

                            if (value == items[0]) {
                              status = 1;
                            } else {
                              status = 2;
                            }
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: 140,
                        itemHeight: 40,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Align(alignment: Alignment.centerLeft, child: buildInfo()),
              SizedBox(height: 32),
            ],
          ),
        ),
      );

  Widget buildInfo() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
                future: tc.showAll(widget._admin, status, 0),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Transaction> lot = [];
                    var result = jsonDecode(snapshot.data!.body);
                    if (snapshot.data!.statusCode == 200) {
                      for (int i = 0; i < result['data'].length; i++) {
                        lot.add(Transaction.fromJson(result['data'][i]));
                      }
                    }
                    return Table(
                      border: TableBorder.all(
                        color: Color(0xffaaaaaa),
                      ),
                      columnWidths: const <int, TableColumnWidth>{
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                            TableRow(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'id',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'tanggal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'nomor resi',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'detail',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] +
                          buildHistoryList(lot),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );

  List<TableRow> buildHistoryList(List<Transaction> lot) {
    List<TableRow> list = [];
    for (int i = 0; i < lot.length; i++) {
      list.add(
        TableRow(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                lot[i].id.toString(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                (lot[i].status == 1 ? 'Belum Diproses' : 'Diterima Penjual'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                lot[i].updated_at + '(UTC)',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                lot[i].nomor_resi,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextButton(
                onPressed: () async {
                  ProductTransactionController ptc =
                      ProductTransactionController();
                  GetCategory _gc = GetCategory(ProductCategoryController());
                  List<ProductCategories> _lopc = await _gc.showAll();
                  var responsep = await ptc.showByTransactionId(lot[i].id);
                  List<Product> lop = [];
                  List<ProductTransaction> lopt = [];
                  if (responsep.statusCode == 200) {
                    var result = jsonDecode(responsep.body);
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
                        'sell_price':
                            double.parse(result['data'][i]['sell_price']),
                        'currrency': result['data'][i]['currrency'],
                        'amount': result['data'][i]['amount'],
                        'product_id': result['data'][i]['product_id'],
                        'transaction_id': result['data'][i]['transaction_id'],
                        'weight': double.parse(
                            result['data'][i]['weight'].toString()),
                      }));
                    }
                  }
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: ((context) => Menu(
                            Selesai(
                              widget._auth,
                              widget._admin,
                              widget._isAuth,
                              widget._isAdmin,
                              widget._gp,
                              lop,
                              lopt,
                              widget._lopc,
                              widget._info,
                              lot[i],
                              lot[i].ongkos,
                              false,
                            ),
                            widget._isAuth,
                            widget._auth,
                            widget._isAdmin,
                            widget._admin,
                            widget._gp,
                            widget._lopc,
                            widget._info,
                          )),
                    ),
                  );
                },
                child: Text(
                  'detail',
                ),
              ),
            ),
          ],
        ),
      );
    }
    return list;
  }
}
