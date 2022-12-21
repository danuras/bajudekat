class User {
  int id = -1;
  String name = '';
  String email = '';
  String phone_number = '';
  String address = '';
  String api_token = '';
  String password = '';
  int city = -1;
  String created_at = '';
  String updated_at = '';
  User();

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        phone_number = json['phone_number'],
        address = json['address'],
        city = int.parse(json['city']),
        api_token = json['api_token'] ?? '',
        created_at = json['created_at'] ?? '',
        updated_at = json['updated_at'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone_number': phone_number,
        'address': address,
        'city': city,
        'api_token': api_token,
        'created_at': created_at,
        'updated_at': updated_at,
      };

  void dispose() {}
}
