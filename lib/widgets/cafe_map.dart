import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/cafe.dart';

class CafeMap extends StatefulWidget {
  final List<Cafe> cafes;

  CafeMap({required this.cafes});

  @override
  _CafeMapState createState() => _CafeMapState();
}

class _CafeMapState extends State<CafeMap> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: widget.cafes.isNotEmpty
            ? widget.cafes.first.location
            : LatLng(0, 0),
        zoom: 12,
      ),
      markers: widget.cafes
          .map((cafe) => Marker(
                markerId: MarkerId(cafe.id),
                position: cafe.location,
                infoWindow: InfoWindow(
                  title: cafe.name,
                  snippet: cafe.address,
                ),
              ))
          .toSet(),
    );
  }
}
