class Admin {
  late int id;
  late String email;
  late String api_token;
  late String created_at;
  late String updated_at;

  Admin();

  Admin.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        api_token = json['api_token'],
        created_at = json['created_at'] ?? '',
        updated_at = json['updated_at'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'api_token': api_token,
        'created_at': created_at,
        'updated_at': updated_at,
      };

  void dispose() {}
}
