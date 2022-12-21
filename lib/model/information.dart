class Information {
  late String short_description;
  late String description;
  late String no_telp;
  late String email;
  late String link_market_place;
  late String link_tiktok;
  late String link_instagram;
  late String link_facebook;
  late String link_twitter;
  late String link_pinterest;
  late String link_linkedin;
  late String link_youtube;
  late String city;
  late String address;

  Information();

  Information.fromJson(Map<String, dynamic> json)
      : short_description = json['short_description'],
        description = json['description'],
        no_telp = json['no_telp'],
        email = json['email'] ?? '',
        link_market_place = json['link_market_place'] ?? '',
        link_tiktok = json['link_tiktok'] ?? '',
        link_instagram = json['link_instagram'] ?? '',
        link_facebook = json['link_facebook'] ?? '',
        link_twitter = json['link_twitter'] ?? '',
        link_pinterest = json['link_pinterest'] ?? '',
        link_linkedin = json['link_linkedin'] ?? '',
        link_youtube = json['link_youtube'] ?? '',
        city = json['city'] ?? '',
        address = json['address'] ?? '';

  Map<String, dynamic> toJson() => {
        'short_desctiption': short_description,
        'description': description,
        'no_telp': no_telp,
        'email': email,
        'link_market_place': link_market_place,
        'link_tiktok': link_tiktok,
        'link_instagram': link_instagram,
        'link_facebook': link_facebook,
        'link_twitter': link_twitter,
        'link_pinterest': link_pinterest,
        'link_linkedin': link_linkedin,
        'link_youtube': link_youtube,
        'city': city,
        'address': address,
      };

  void dispose() {}
}
