import 'package:http/http.dart' as http;

class RajaOngkir {
  static Future<http.Response> getCity() async {
    var uri = Uri.parse('https://api.rajaongkir.com/starter/city');

    var request = http.MultipartRequest('GET', uri);
    request.headers['key'] = 'keyRajaOngkir';
    var hasil = await request.send();
    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  static Future<http.Response> getCityById(int id) async {
    var uri = Uri.parse(
      'https://api.rajaongkir.com/starter/city?id=$id',
    );
    var request = http.MultipartRequest('GET', uri);
    request.headers['key'] = 'keyRajaOngkir';
    var hasil = await request.send();
    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  static Future<http.Response> getCost(int dest, int ori, double weight) async {
    var uri = Uri.parse(
      'https://api.rajaongkir.com/starter/cost',
    );
    var request = http.MultipartRequest('POST', uri);
    request.headers['key'] = 'keyRajaOngkir';
    request.fields['destination'] = dest.toString();
    request.fields['origin'] = ori.toString();
    request.fields['weight'] = weight.toString();
    request.fields['courier'] = 'jne';

    var hasil = await request.send();
    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }
}
