class ProductTransaction {
  final int id;
  final double buy_price;
  final double sell_price;
  final double weight;
  final String currency;
  final int amount;
  final int product_id;
  final int transaction_id;
  final String created_at;
  final String updated_at;

  ProductTransaction(
    this.id,
    this.buy_price,
    this.sell_price,
    this.weight,
    this.currency,
    this.amount,
    this.product_id,
    this.transaction_id,
    this.created_at,
    this.updated_at,
  );

  ProductTransaction.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        buy_price = json['buy_price'] ?? 0,
        sell_price = json['sell_price'],
        weight = json['weight'],
        currency = json['currency'] ?? 'IDR',
        amount = json['amount'],
        product_id = json['product_id'] ?? 0,
        transaction_id = json['transaction_id'] ?? 0,
        created_at = json['created_at'] ?? '',
        updated_at = json['updated_at'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'buy_price': buy_price,
        'sell_price': sell_price,
        'weight': weight,
        'currency': currency,
        'amount': amount,
        'product_id': product_id,
        'transaction_id': transaction_id,
        'created_at': created_at,
        'updated_at': updated_at,
      };

  void dispose() {}
}
