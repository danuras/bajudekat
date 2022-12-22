import 'package:baju_dekat/view_controller/api/endpoint.dart';
import 'package:http/http.dart' as http;

class RajaOngkir {
  static Future<http.Response> getCity() async {
    var uri = Uri.https(EndPoint.value, 'api/user/rajaongkir/getCity');

    var request = http.MultipartRequest('GET', uri);
    var hasil = await request.send();
    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  static Future<http.Response> getCityById(int id) async {
    var uri = Uri.https(
      EndPoint.value,
      'api/user/rajaongkir/getCityById',
    );
    var request = http.MultipartRequest('POST', uri);
    request.fields['id'] = id.toString();

    var hasil = await request.send();
    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }

  static Future<http.Response> getCost(int dest, int ori, double weight) async {
    var uri = Uri.https(
      EndPoint.value,
      'api/user/rajaongkir/getCost',
    );
    var request = http.MultipartRequest('POST', uri);
    request.fields['destination'] = dest.toString();
    request.fields['origin'] = ori.toString();
    request.fields['weight'] = weight.toString();
    request.fields['courier'] = 'jne';

    var hasil = await request.send();
    http.Response response = await http.Response.fromStream(hasil);

    return response;
  }
}
