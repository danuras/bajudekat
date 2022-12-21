class Transaction {
  final int id;
  final int status;
  final int cust_id;
  final String nomor_resi;
  final String address;
  final String kurir;
  final double total;
  final int ongkos;
  final String payment;
  final String created_at;
  final String updated_at;

  Transaction(
    this.id,
    this.status,
    this.cust_id,
    this.nomor_resi,
    this.address,
    this.kurir,
    this.total,
    this.ongkos,
    this.payment,
    this.created_at,
    this.updated_at,
  );

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'] ?? 1,
        cust_id = json['cust_id'],
        nomor_resi = json['nomor_resi'] ?? '',
        address = json['address'] ?? 0,
        kurir = json['kurir'] ?? '',
        total = double.parse((json['total'] ?? 0).toString()),
        ongkos = json['ongkos'] ?? 0,
        payment = json['payment'] ?? '',
        created_at = json['created_at'] ?? '',
        updated_at = json['updated_at'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'cust_id': cust_id,
        'nomor_resi': nomor_resi,
        'address': address,
        'kurir': kurir,
        'total': total,
        'ongkos': ongkos,
        'payment': payment,
        'created_at': created_at,
        'updated_at': updated_at,
      };

  void dispose() {}
}
