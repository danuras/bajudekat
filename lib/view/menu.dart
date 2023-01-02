import 'dart:convert';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:baju_dekat/model/admin.dart';
import 'package:baju_dekat/model/auth.dart';
import 'package:baju_dekat/model/information.dart';
import 'package:baju_dekat/model/product.dart';
import 'package:baju_dekat/model/product_categories.dart';
import 'package:baju_dekat/model/product_transaction.dart';
import 'package:baju_dekat/model/transaction.dart';
import 'package:baju_dekat/model/user.dart';
import 'package:baju_dekat/view/about/about.dart';
import 'package:baju_dekat/view/admin/information_web.dart';
import 'package:baju_dekat/view/admin/list_pesanan.dart';
import 'package:baju_dekat/view/admin/menejemen_produk.dart';
import 'package:baju_dekat/view/auth/enter_code.dart';
import 'package:baju_dekat/view/auth/register.dart';
import 'package:baju_dekat/view/basket/basket.dart';
import 'package:baju_dekat/view/contact/contact.dart';
import 'package:baju_dekat/view/footer.dart';
import 'package:baju_dekat/view/history/history.dart';
import 'package:baju_dekat/view/home/home.dart';
import 'package:baju_dekat/view/list_product/list_product.dart';
import 'package:baju_dekat/view/navbar.dart';
import 'package:baju_dekat/view/product_card.dart';
import 'package:baju_dekat/view/profile/profile.dart';
import 'package:baju_dekat/view/search_bar.dart';
import 'package:baju_dekat/view_controller/api/auth_controller.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:baju_dekat/view_controller/api/product_category_controller.dart';
import 'package:baju_dekat/view_controller/api/product_transaction_controller.dart';
import 'package:baju_dekat/view_controller/api/raja_ongkir.dart';
import 'package:baju_dekat/view_controller/api/transaction_controller.dart';
import 'package:baju_dekat/view_controller/api/user_controller.dart';
import 'package:baju_dekat/view_controller/controller/get_category.dart';
import 'package:baju_dekat/view_controller/controller/get_product.dart';

class Menu extends StatefulWidget {
  Menu(this._page, this._isAuth, this._auth, this._isAdmin, this._admin,
      this._gp, this._lopc, this._info,
      {super.key});
  bool _isAuth;
  bool _isAdmin;
  Auth _auth;
  Admin _admin;
  Widget _page;
  GetProduct _gp;
  List<ProductCategories> _lopc;
  Information _info;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _categoryScroll = ScrollController();
  late Widget _listCategory;

  int idx = 0;

  final AuthController _authController = AuthController();
  final _searchController = TextEditingController(text: '');

  bool isShowS = false;
  late List<Widget> _listOfBar;
  late List<String> items = [
    'Menejemen Produk',
    'List Pesanan',
    'Informasi Web'
  ];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _listOfBar = [
      Container(
        width: 80,
        height: double.infinity,
        child: InkWell(
          onTap: () async {
            List<Product> _lod = await widget._gp.getDiscount(0);
            List<Product> _lop = await widget._gp.getAllProduct('%%', 0);
            int _dl = await widget._gp.countDiscount();
            int _pl = await widget._gp.countBySearch('%%');

            GetCategory _gc = GetCategory(ProductCategoryController());
            List<ProductCategories> _lopc = await _gc.showAll();
            if (!mounted) {
              return;
            }
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: ((context) {
                return Menu(
                  Home(
                    widget._isAuth,
                    widget._auth,
                    widget._isAdmin,
                    widget._admin,
                    _lod,
                    _lop,
                    widget._gp,
                    _dl,
                    _pl,
                    widget._lopc,
                    widget._info,
                  ),
                  widget._isAuth,
                  widget._auth,
                  widget._isAdmin,
                  widget._admin,
                  widget._gp,
                  widget._lopc,
                  widget._info,
                );
              }),
            ));
          },
          child: const Center(
              child: Text(
            'Home',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff737fb3),
                fontWeight: FontWeight.bold),
          )),
        ),
      ),
      Container(
        width: 80,
        height: double.infinity,
        child: InkWell(
          onTap: () async {
            UserController uc = UserController();
            var response = await uc.show(widget._auth);
            if (response.statusCode == 200) {
              var result = jsonDecode(response.body);
              User user = User.fromJson(result['data'][0]);

              GetCategory _gc = GetCategory(ProductCategoryController());
              List<ProductCategories> _lopc = await _gc.showAll();
              if (!mounted) {
                return;
              }
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: ((context) => Menu(
                        Profile(
                          user,
                          widget._auth,
                          widget._isAdmin,
                          widget._isAuth,
                          widget._admin,
                          widget._gp,
                          _lopc,
                          widget._info,
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
            } else if (response.statusCode == 350) {
              var result = jsonDecode(response.body);
              User user = User.fromJson(result['data']);

              GetCategory _gc = GetCategory(ProductCategoryController());
              List<ProductCategories> _lopc = await _gc.showAll();
              if (!mounted) {
                return;
              }
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, __, ___) => EnterCode(
                    user.email,
                    widget._auth,
                    widget._isAdmin,
                    widget._admin,
                    widget._gp,
                    _lopc,
                    widget._info,
                  ),
                ),
              );
            } else {
              if (!mounted) {
                return;
              }
              AuthController au = AuthController();
              var result = jsonDecode(response.body);

              GetCategory _gc = GetCategory(ProductCategoryController());
              List<ProductCategories> _lopc = await _gc.showAll();
              await au.logout(widget._auth);
              widget._isAuth = true;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result['message'].toString()),
                ),
              );
            }
          },
          child: const Center(
              child: Text(
            'Profil',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff737fb3),
                fontWeight: FontWeight.bold),
          )),
        ),
      ),
      Container(
        width: 80,
        height: double.infinity,
        child: InkWell(
          onTap: () async {
            GetCategory _gc = GetCategory(ProductCategoryController());
            List<ProductCategories> _lopc = await _gc.showAll();

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: ((context) => Menu(
                      History(
                        widget._admin,
                        widget._isAdmin,
                        widget._auth,
                        widget._isAuth,
                        widget._gp,
                        _lopc,
                        widget._info,
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
          child: const Center(
              child: Text(
            'History',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff737fb3),
                fontWeight: FontWeight.bold),
          )),
        ),
      ),
      Container(
        width: 80,
        height: double.infinity,
        child: InkWell(
          onTap: () async {
            GetCategory _gc = GetCategory(ProductCategoryController());
            List<ProductCategories> _lopc = await _gc.showAll();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: ((context) => Menu(
                      Contact(
                        widget._admin,
                        widget._isAdmin,
                        widget._auth,
                        widget._isAuth,
                        widget._gp,
                        _lopc,
                        widget._info,
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
          child: const Center(
              child: Text(
            'Kontak',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff737fb3),
                fontWeight: FontWeight.bold),
          )),
        ),
      ),
      Container(
        width: 80,
        height: double.infinity,
        child: InkWell(
          onTap: () async {
            GetCategory _gc = GetCategory(ProductCategoryController());
            List<ProductCategories> _lopc = await _gc.showAll();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: ((context) => Menu(
                      About(
                        widget._auth,
                        widget._admin,
                        widget._isAuth,
                        widget._isAdmin,
                        widget._gp,
                        widget._lopc,
                        widget._info,
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
          child: const Center(
            child: Text(
              'Tentang',
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff737fb3),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      (widget._isAuth)
          ? Container(
              width: 80,
              height: double.infinity,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Register(
                        widget._isAdmin,
                        widget._admin,
                        widget._gp,
                        widget._lopc,
                        widget._info,
                      ),
                    ),
                  );
                },
                child: const Center(
                    child: Text(
                  'Daftar',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff737fb3),
                      fontWeight: FontWeight.bold),
                )),
              ),
            )
          : SizedBox(),
      (widget._isAuth)
          ? Container(
              width: 80,
              height: double.infinity,
              child: InkWell(
                onTap: () async {
                  GetCategory _gc = GetCategory(ProductCategoryController());
                  List<ProductCategories> _lopc = await _gc.showAll();
                  AuthController au = AuthController();
                  au.isAuth(
                    widget._isAuth,
                    widget._auth,
                    context,
                    widget._isAdmin,
                    widget._admin,
                    widget._gp,
                    _lopc,
                    widget._info,
                  );
                },
                child: const Center(
                    child: Text(
                  'Masuk',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff737fb3),
                      fontWeight: FontWeight.bold),
                )),
              ),
            )
          : const SizedBox(),
      (widget._isAdmin)
          ? DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: const Icon(
                  Icons.menu,
                  size: 30,
                  color: Color(0xff737fb3),
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
                onChanged: (value) async {
                  if (value == 'Menejemen Produk') {
                    List<Product> _lop =
                        await widget._gp.getAllProduct('%%', 0);

                    GetCategory _gc = GetCategory(ProductCategoryController());
                    List<ProductCategories> _lopc = await _gc.showAll();
                    int _lol = await widget._gp.countBySearch('%%');
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: ((context) => Menu(
                              MenejemenProduct(
                                'Menejemen Produk',
                                widget._admin,
                                widget._isAdmin,
                                widget._auth,
                                widget._isAuth,
                                widget._gp,
                                _lop,
                                _lol,
                                0,
                                widget._lopc,
                                widget._info,
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
                  } else if (value == 'List Pesanan') {
                    GetCategory _gc = GetCategory(ProductCategoryController());
                    List<ProductCategories> _lopc = await _gc.showAll();

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: ((context) => Menu(
                              ListPesanan(
                                widget._admin,
                                widget._isAdmin,
                                widget._auth,
                                widget._isAuth,
                                widget._gp,
                                widget._lopc,
                                widget._info,
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
                  } else if (value == 'Informasi Web') {
                    GetCategory _gc = GetCategory(ProductCategoryController());
                    List<ProductCategories> _lopc = await _gc.showAll();

                    var response = await RajaOngkir.getCityById(
                      int.parse(widget._info.city),
                    );
                    var result = jsonDecode(response.body);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: ((context) => Menu(
                              InformationWeb(
                                widget._auth,
                                widget._admin,
                                widget._isAuth,
                                widget._isAdmin,
                                widget._gp,
                                widget._lopc,
                                widget._info,
                                result['rajaongkir']['results']['city_name'],
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
                  }
                },
                dropdownWidth: 200,
                buttonWidth: 80,
              ),
            )
          : SizedBox(),
    ];

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _authController.isAuth(
        widget._isAuth,
        widget._auth,
        context,
        widget._isAdmin,
        widget._admin,
        widget._gp,
        widget._lopc,
        widget._info,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: MediaQuery.of(context).size.width < 1110,
        title: Image.asset(
          'assets/logo-ori.png',
          height: 30,
        ),
        iconTheme: IconThemeData(color: Color(0xff737fb3)),
        actions: ((MediaQuery.of(context).size.width > 1110)
                ? _listOfBar
                : [SizedBox(), Text('')]) +
            [
              (MediaQuery.of(context).size.width > 560)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        height: 20,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            fillColor: Colors.white,
                            hintText: "Search",
                            hintStyle: TextStyle(fontSize: 14),
                            suffixIcon: Icon(Icons.search),
                            filled: true,
                          ),
                          onSubmitted: (value) async {
                            List<Product> _lop = await widget._gp.getAllProduct(
                                '%' + _searchController.text + '%', 0);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: ((context) => Menu(
                                      ListProduct(
                                        'Hasil: ' + _searchController.text,
                                        widget._admin,
                                        widget._auth,
                                        widget._isAdmin,
                                        widget._isAuth,
                                        _lop,
                                        _lop.length,
                                        0,
                                        0,
                                        widget._gp,
                                        widget._lopc,
                                        widget._info,
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
                          controller: _searchController,
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.search, color: Color(0xff737fb3)),
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, __, ___) {
                              return SearchBar(
                                _searchController,
                                widget._admin,
                                widget._auth,
                                widget._isAdmin,
                                widget._isAuth,
                                widget._gp,
                                widget._lopc,
                                widget._info,
                              );
                            },
                          ),
                        );
                      },
                    ),
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Color(0xff737fb3)),
                onPressed: () async {
                  ProductTransactionController ptc =
                      ProductTransactionController();
                  GetCategory _gc = GetCategory(ProductCategoryController());
                  List<ProductCategories> _lopc = await _gc.showAll();
                  var response = await ptc.showBasket(widget._auth);
                  List<Product> lop = [];
                  List<ProductTransaction> lopt = [];
                  if (response.statusCode == 200) {
                    var result = jsonDecode(response.body);
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Basket(
                        widget._auth,
                        widget._isAuth,
                        widget._isAdmin,
                        widget._admin,
                        widget._gp,
                        _lopc,
                        lop,
                        lopt,
                        widget._info,
                      ),
                    ),
                  );
                },
              ),
            ],
      ),
      backgroundColor: Color(0xffdddddd),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 50,
                      maxWidth: 1200,
                    ),
                    child: widget._page,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Footer(
              widget._info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return SizedBox(
      //membuat menu drawer
      child: Drawer(
        //membuat list,
        //list digunakan untuk melakukan scrolling jika datanya terlalu panjang
        child: ListView(
          padding: EdgeInsets.zero,
          //di dalam listview ini terdapat beberapa widget drawable
          children: [
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text(
                "Home",
              ),
              onTap: () async {
                List<Product> _lod = await widget._gp.getDiscount(0);
                List<Product> _lop = await widget._gp.getAllProduct('%%', 0);
                int _dl = await widget._gp.countDiscount();
                int _pl = await widget._gp.countBySearch('%%');

                GetCategory _gc = GetCategory(ProductCategoryController());
                List<ProductCategories> _lopc = await _gc.showAll();
                if (!mounted) {
                  return;
                }
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: ((context) {
                    return Menu(
                      Home(
                        widget._isAuth,
                        widget._auth,
                        widget._isAdmin,
                        widget._admin,
                        _lod,
                        _lop,
                        widget._gp,
                        _dl,
                        _pl,
                        widget._lopc,
                        widget._info,
                      ),
                      widget._isAuth,
                      widget._auth,
                      widget._isAdmin,
                      widget._admin,
                      widget._gp,
                      widget._lopc,
                      widget._info,
                    );
                  }),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profil"),
              onTap: () async {
                UserController uc = UserController();
                var response = await uc.show(widget._auth);
                if (response.statusCode == 200) {
                  var result = jsonDecode(response.body);
                  User user = User.fromJson(result['data'][0]);

                  GetCategory _gc = GetCategory(ProductCategoryController());
                  List<ProductCategories> _lopc = await _gc.showAll();
                  if (!mounted) {
                    return;
                  }
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: ((context) => Menu(
                            Profile(
                              user,
                              widget._auth,
                              widget._isAdmin,
                              widget._isAuth,
                              widget._admin,
                              widget._gp,
                              _lopc,
                              widget._info,
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
                } else if (response.statusCode == 350) {
                  var result = jsonDecode(response.body);
                  User user = User.fromJson(result['data']);

                  GetCategory _gc = GetCategory(ProductCategoryController());
                  List<ProductCategories> _lopc = await _gc.showAll();
                  if (!mounted) {
                    return;
                  }
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, __, ___) => EnterCode(
                        user.email,
                        widget._auth,
                        widget._isAdmin,
                        widget._admin,
                        widget._gp,
                        _lopc,
                        widget._info,
                      ),
                    ),
                  );
                } else {
                  var result = jsonDecode(response.body);

                  GetCategory _gc = GetCategory(ProductCategoryController());
                  List<ProductCategories> _lopc = await _gc.showAll();
                  AuthController au = AuthController();

                  await au.logout(widget._auth);
                  widget._isAuth = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message'].toString()),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("History"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: ((context) => Menu(
                          History(
                            widget._admin,
                            widget._isAdmin,
                            widget._auth,
                            widget._isAuth,
                            widget._gp,
                            widget._lopc,
                            widget._info,
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
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.call),
              title: Text("Kontak"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: ((context) => Menu(
                          Contact(
                            widget._admin,
                            widget._isAdmin,
                            widget._auth,
                            widget._isAuth,
                            widget._gp,
                            widget._lopc,
                            widget._info,
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
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Tentang"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: ((context) => Menu(
                          About(
                            widget._auth,
                            widget._admin,
                            widget._isAuth,
                            widget._isAdmin,
                            widget._gp,
                            widget._lopc,
                            widget._info,
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
            ),
            (widget._isAuth)
                ? ListTile(
                    leading: Icon(Icons.app_registration),
                    title: Text("Daftar"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Register(
                            widget._isAdmin,
                            widget._admin,
                            widget._gp,
                            widget._lopc,
                            widget._info,
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(),
            (widget._isAuth)
                ? ListTile(
                    leading: Icon(Icons.login),
                    title: Text("Masuk"),
                    onTap: () async {
                      GetCategory _gc =
                          GetCategory(ProductCategoryController());
                      List<ProductCategories> _lopc = await _gc.showAll();
                      AuthController au = AuthController();
                      au.isAuth(
                        widget._isAuth,
                        widget._auth,
                        context,
                        widget._isAdmin,
                        widget._admin,
                        widget._gp,
                        _lopc,
                        widget._info,
                      );
                    },
                  )
                : SizedBox(),
            (widget._isAdmin) ? Divider() : SizedBox(),
            (widget._isAdmin)
                ? ListTile(
                    leading: Icon(Icons.gif_box),
                    title: Text("Menejemen Produk"),
                    onTap: () async {
                      List<Product> _lop =
                          await widget._gp.getAllProduct('%%', 0);

                      int _lol = await widget._gp.countBySearch('%%');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: ((context) => Menu(
                                MenejemenProduct(
                                  'Menejemen Produk',
                                  widget._admin,
                                  widget._isAdmin,
                                  widget._auth,
                                  widget._isAuth,
                                  widget._gp,
                                  _lop,
                                  _lol,
                                  0,
                                  widget._lopc,
                                  widget._info,
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
                  )
                : SizedBox(),
            (widget._isAdmin)
                ? ListTile(
                    leading: Icon(Icons.list_alt),
                    title: Text("List Pesanan"),
                    onTap: () async {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: ((context) => Menu(
                                ListPesanan(
                                  widget._admin,
                                  widget._isAdmin,
                                  widget._auth,
                                  widget._isAuth,
                                  widget._gp,
                                  widget._lopc,
                                  widget._info,
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
                  )
                : SizedBox(),
            (widget._isAdmin)
                ? ListTile(
                    leading: Icon(Icons.people),
                    title: Text("Informasi Web"),
                    onTap: () async {
                      var response = await RajaOngkir.getCityById(
                        int.parse(widget._info.city),
                      );
                      var result = jsonDecode(response.body);

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: ((context) => Menu(
                                InformationWeb(
                                  widget._auth,
                                  widget._admin,
                                  widget._isAuth,
                                  widget._isAdmin,
                                  widget._gp,
                                  widget._lopc,
                                  widget._info,
                                  result['rajaongkir']['results']['city_name'],
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
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
