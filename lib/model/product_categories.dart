class ProductCategories {
  final int id;
  final String name;

  ProductCategories(
    this.id,
    this.name,
  );

  ProductCategories.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  void dispose() {}
}
