import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/product_transaction.dart';
import 'package:baju_dekat/model/transaction.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/admin/components/terima_pesanan.dart';
import 'package:baju_dekat/view/admin/login_admin.dart';
import 'package:baju_dekat/view/basket/product_banner.dart';
import 'package:baju_dekat/view/component/tablet_button.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/menu.dart';
import 'package:baju_dekat/view/navbar.dart';
import 'package:baju_dekat/view_controller/api/admin_controller.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:baju_dekat/view_controller/api/user_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';
import 'package:url_launcher/url_launcher.dart';

class Selesai extends StatefulWidget {
  const Selesai(
      this._auth,
      this._admin,
      this._isAuth,
      this._isAdmin,
      this._gp,
      this._lop,
      this._lopt,
      this._lopc,
      this._info,
      this._t,
      this.ongkos,
      this._isDisable,
      {super.key});
  final Auth _auth;
  final Admin _admin;
  final bool _isAuth;
  final bool _isAdmin;
  final GetProduct _gp;
  final List<Product> _lop;
  final List<ProductTransaction> _lopt;
  final List<ProductCategories> _lopc;
  final Information _info;
  final Transaction _t;
  final int ongkos;
  final bool _isDisable;

  @override
  State<Selesai> createState() => _SelesaiState();
}

class _SelesaiState extends State<Selesai> {
  final double coverHeight = 280, profileHeight = 144;
  late User _user;
  late UserController _userController;
  late Future<http.Response> _bar;

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
              SizedBox(height: 16),
              Align(
                  alignment: Alignment.centerLeft,
                  child: (widget._t.status == 1)
                      ? buildInfo()
                      : buildInfoDiterima()),
              Padding(
                padding: const EdgeInsets.only(
                  right: 50.0,
                  top: 50.0,
                ),
                child: Material(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      );
  Widget buildInfoDiterima() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan Diterima',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Silahkan hubungi nomer berikut untuk apabila ingin bertanya.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text('WA: '),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    widget._info.no_telp,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text('Nomor Resi: '),
                Text(
                  widget._t.nomor_resi,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Daftar Produk',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ResponsiveGridRow(
              children: listOfProduct(),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Rincian transaksi',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total Harga Produk: Rp ' + widget._t.total.toString(),
            ),
            Text(
              'Biaya Pengiriman: Rp ' +
                  ((widget.ongkos != -1) ? widget.ongkos.toString() : '...'),
            ),
            Text(
              'Total: Rp ' +
                  ((widget.ongkos != -1)
                      ? (widget._t.total + widget.ongkos).toString()
                      : '...'),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );

  Widget buildInfo() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan Terkirim',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Silahkan hubungi nomer berikut untuk melakukan pembayaran.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text('WA: '),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    widget._info.no_telp,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Daftar Produk',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ResponsiveGridRow(
              children: listOfProduct(),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Rincian transaksi',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total Harga Produk: Rp ' + widget._t.total.toString(),
            ),
            Text(
              'Biaya Pengiriman: Rp ' +
                  ((widget.ongkos != -1) ? widget.ongkos.toString() : '...'),
            ),
            Text(
              'Total: Rp ' +
                  ((widget.ongkos != -1)
                      ? (widget._t.total + widget.ongkos).toString()
                      : '...'),
            ),
            SizedBox(
              height: 20,
            ),
            (widget._isAdmin)
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: TabletButton(
                      text: 'Terima Pesanan',
                      action: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) => TerimaPesanan(
                                  widget._admin,
                                  widget._isAdmin,
                                  widget._auth,
                                  widget._isAuth,
                                  widget._gp,
                                  widget._lopc,
                                  widget._info,
                                  widget._t.id,
                                )),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
      );

  List<ResponsiveGridCol> listOfProduct() {
    List<ResponsiveGridCol> list = [];
    for (int i = 0; i < widget._lop.length; i++) {
      list.add(
        ResponsiveGridCol(
          xs: 12,
          md: 6,
          child: ProductBanner(
            widget._auth,
            widget._admin,
            widget._isAuth,
            widget._isAdmin,
            widget._gp,
            widget._lop[i],
            widget._lopt[i],
            widget._info,
            widget._isDisable,
          ),
        ),
      );
    }
    return list;
  }
}
