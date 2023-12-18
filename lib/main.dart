import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}
class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> allMarkers = [];
  String? tappedCoordinate;



  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }



  void _handleMapTap(TapPosition pos, LatLng latlng) {
    final String lat = latlng.latitude.toStringAsFixed(6);
    final String lon = latlng.longitude.toStringAsFixed(6);
    final String coordinate = 'Latitude: $lat, Longitude: $lon';

    setState(() {
      tappedCoordinate = coordinate;
    });

    print('Map tapped at: $latlng');
    print('Coordinate: $coordinate');

    _saveLocationToApi(latlng);
    _loadMarkers();
  }


  Future<void> _loadMarkers() async {
    final locations = await ApiService.fetchLocationsFromApi();

    setState(() {
      allMarkers = locations
          .where((location) =>
      location.latitude >= -90 && location.latitude <= 90)
          .map((location) => Marker(
        point: LatLng(location.latitude, location.longitude),
        width: 80.0,
        height: 80.0,
        child: FlutterLogo(size: 80.0),
      ))
          .toList();
    });
  }
  void _onMapTap(LatLng latlng) {
    // Cek apakah lokasi yang diklik sudah memiliki marker
    final bool locationExists = allMarkers.any((marker) =>
    marker.point.latitude == latlng.latitude &&
        marker.point.longitude == latlng.longitude);

    if (locationExists) {
      // Jika marker sudah ada, tampilkan informasi
      _showMarkerInfoDialog(latlng);
    } else {
      // Jika marker belum ada, tambahkan marker baru
      _saveLocationToApi(latlng);
      _loadMarkers();
    }
  }

  void _onMarkerTap(double latitude, double longitude) {
    final String lat = latitude.toStringAsFixed(6);
    final String lon = longitude.toStringAsFixed(6);
    final String coordinate = 'Latitude: $lat, Longitude: $lon';

    setState(() {
      tappedCoordinate = coordinate;
    });

    print('Marker tapped at: $lat, $lon');
    print('Coordinate: $coordinate');
    _showMarkerInfoDialog(coordinate as LatLng);
  }

  void _showMarkerInfoDialog(LatLng latlng) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Marker Information'),
          content: Column(
            children: [
              Text('Coordinate: ${latlng.latitude}, ${latlng.longitude}'),
              SizedBox(height: 10),
              Text('Lorem Ipsum'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  // void _handleMapTap(TapPosition pos, LatLng latlng) {
  //   print('Map tapped at: $latlng');
  //   _saveLocationToApi(latlng);
  //   _loadMarkers();
  // }
  //
  void _saveLocationToApi(LatLng latlng) {
    ApiService.saveLocationToApi(latlng);
    print('Location saved to API successfully');
  }

  // void _handleTap(TapPosition pos, LatLng latlng) {
  //   ApiService.saveLocationToApi(latlng);
  //   _loadMarkers();
  //   print('Location saved to API successfully');
  // }



// void _saveLocationToApi(LatLng latlng) {
//   ApiService.saveLocationToApi(latlng);
// }
//
// class MapScreen extends StatelessWidget {
//
//   void _handleTap(TapPosition pos, LatLng latlng) {
//     _saveLocationToApi(latlng);
//   }
//
//   void _saveLocationToApi(LatLng latlng) {
//     ApiService.saveLocationToApi(latlng);
//     print('Location saved to API successfully');
//   }
  //data for slidingup
  final String data1 = "DATA LOKASI 1";
  final String data2 = "DATA LOKASI 2";
  final String data3 = "DATA LOKASI 3";
  final String data4 = "DATA LOKASI 4";
  late String dataSlide;
  late double long;
  late double lat;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Map Demo'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-7.786405779580295, 110.37881955588135),
          initialZoom: 17,
          onTap: _handleMapTap,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),

          MarkerLayer(
            markers: allMarkers,
          )
        ],
      ),
      // Ganti bagian body dengan BottomSheet
      bottomSheet: tappedCoordinate != null
          ? BottomSheet(
        onClosing: () {},
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tapped Coordinate:'),
                SizedBox(height: 8),
                Text(tappedCoordinate!),
                SizedBox(height: 16),
                Text('Additional Information:'),
                SizedBox(height: 8),
                Text('Lorem Ipsum'),
              ],
            ),
          );
        },
      )
          : null,
    );
  }
}
