import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/cafe.dart';
import '../services/cafe_service.dart';
import 'add_cafe_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  final CafeService _cafeService = CafeService();

  @override
  void initState() {
    super.initState();
    _loadCafes();
  }

  void _loadCafes() async {
    final cafes = await _cafeService.getCafes();
    setState(() {
      _markers = cafes.map((cafe) => Marker(
        markerId: MarkerId(cafe.id),
        position: LatLng(cafe.latitude, cafe.longitude),
        infoWindow: InfoWindow(
          title: cafe.name,
          snippet: cafe.address,
          onTap: () => _showCafeDetails(cafe),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      )).toSet();
    });
  }

  void _showCafeDetails(Cafe cafe) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(cafe.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 8),
              Text(cafe.address, style: TextStyle(color: Colors.grey[600])),
              SizedBox(height: 8),
              Text('Horario: ${cafe.openingHours}', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(-34.9011, -56.1645), // Montevideo
              zoom: 13,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: IconButton(
                icon: Icon(Icons.person, color: Colors.grey[700]),
                onPressed: () {
                  // Implementar acción para perfil de usuario
                },
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.grey[700]),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCafeScreen()),
                      ).then((_) => _loadCafes());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.orange),
                    onPressed: () {
                      // Implementar acción para búsqueda
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.grey[700]),
                    onPressed: () {
                      // Implementar acción para favoritos
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
