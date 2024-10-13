import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cafe_service.dart';
import '../widgets/cafe_list_item.dart';

class CafeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Cafeterías')),
      body: Consumer<CafeService>(
        builder: (context, cafeService, child) {
          if (cafeService.cafes.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: cafeService.cafes.length,
            itemBuilder: (context, index) {
              return CafeListItem(cafe: cafeService.cafes[index]);
            },
          );
        },
      ),
    );
  }
}
