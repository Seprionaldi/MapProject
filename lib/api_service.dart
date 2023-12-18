import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'location_model.dart'; // Sesuaikan dengan struktur folder dan nama file yang benar

class ApiService {
  static Future<void> saveLocationToApi(LatLng latlng) async {
    const apiUrl = 'http://10.139.18.196:8000/api/locationspost';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'latitude': latlng.latitude.toString(),
        'longitude': latlng.longitude.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Location saved to API successfully');
    } else {
      print('Failed to save location to API');
    }
  }

  static Future<List<Location>> fetchLocationsFromApi() async {
    const apiUrl = 'http://10.139.18.196:8000/api/locationsget';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      final List<Location> locations =
      data.map((item) => Location.fromJson(item)).toList();
      return locations;
    } else {
      throw Exception('Failed to load locations from API');
    }
  }
}
