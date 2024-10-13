import 'package:google_maps_flutter/google_maps_flutter.dart';


class Cafe {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String openingHours;
  bool isFavorite;

  Cafe({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.openingHours,
    this.isFavorite = false,
  });

    LatLng get location => LatLng(latitude, longitude);

}
