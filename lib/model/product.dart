class Product {
  final int id;
  final String name;
  final String image_url;
  final String categories_name;
  final String description;
  final double buy_price;
  final double sell_price;
  final String currency;
  final int stock;
  final double weight;
  final double discount;
  final bool isBasket;
  final String discount_expired_at;
  final String created_at;
  final String updated_at;

  Product(
    this.id,
    this.name,
    this.image_url,
    this.categories_name,
    this.description,
    this.buy_price,
    this.sell_price,
    this.currency,
    this.stock,
    this.weight,
    this.discount,
    this.isBasket,
    this.discount_expired_at,
    this.created_at,
    this.updated_at,
  );

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? -1,
        name = json['name'] ?? '',
        image_url = json['image_url'] ?? '',
        categories_name = json['categories_name'] ?? '',
        description = json['description'] ?? '',
        buy_price = double.parse(json['buy_price'] ?? '0'),
        sell_price = double.parse(json['sell_price'] ?? '0'),
        currency = json['currency'] ?? 'IDR',
        stock = int.parse((json['stock'] ?? '0').toString()),
        weight = double.parse((json['weight'] ?? 0).toString()),
        discount = double.parse((json['discount'] ?? 0).toString()),
        isBasket = json['isBasket'] == 1,
        discount_expired_at = json['discount_expired_at'] ?? '',
        created_at = json['created_at'] ?? '',
        updated_at = json['updated_at'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': image_url,
        'categories_name': categories_name,
        'description': description,
        'buy_price': buy_price,
        'sell_price': sell_price,
        'currency': currency,
        'stock': stock,
        'weight': weight,
        'discount': discount,
        'isBasket': isBasket,
        'discount_expired_at': discount_expired_at,
        'created_at': created_at,
        'updated_at': updated_at,
      };

  void dispose() {}
}
