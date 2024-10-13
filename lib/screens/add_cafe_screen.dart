import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/cafe.dart';
import '../services/cafe_service.dart';

class AddCafeScreen extends StatefulWidget {
  @override
  _AddCafeScreenState createState() => _AddCafeScreenState();
}

class _AddCafeScreenState extends State<AddCafeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _scheduleController = TextEditingController();
  LatLng _selectedLocation = LatLng(-34.9011, -56.1645); // Montevideo
  final CafeService _cafeService = CafeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Cafetería')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Dirección'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una dirección';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _scheduleController,
              decoration: InputDecoration(labelText: 'Horario'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un horario';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation,
                  zoom: 13,
                ),
                onTap: (LatLng latLng) {
                  setState(() {
                    _selectedLocation = latLng;
                  });
                },
                markers: {
                  Marker(
                    markerId: MarkerId('selectedLocation'),
                    position: _selectedLocation,
                  ),
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Agregar Cafetería'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newCafe = Cafe(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        address: _addressController.text,
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
        openingHours: _scheduleController.text,
      );

      await _cafeService.addCafe(newCafe);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cafetería agregada con éxito')),
      );

      Navigator.pop(context);
    }
  }
}
