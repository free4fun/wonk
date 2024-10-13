import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cafe_service.dart';
import '../widgets/cafe_list_item.dart';

class FavoriteCafesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cafeterías Favoritas')),
      body: Consumer<CafeService>(
        builder: (context, cafeService, child) {
          final favoriteCafes = cafeService.favoriteCafes;
          if (favoriteCafes.isEmpty) {
            return Center(child: Text('No tienes cafeterías favoritas'));
          }
          return ListView.builder(
            itemCount: favoriteCafes.length,
            itemBuilder: (context, index) {
              return CafeListItem(cafe: favoriteCafes[index]);
            },
          );
        },
      ),
    );
  }
}
