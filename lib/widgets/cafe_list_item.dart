import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cafe.dart';
import '../services/cafe_service.dart';

class CafeListItem extends StatelessWidget {
  final Cafe cafe;

  CafeListItem({required this.cafe});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cafe.name),
      subtitle: Text(cafe.address),
      trailing: IconButton(
        icon: Icon(
          cafe.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: cafe.isFavorite ? Colors.red : null,
        ),
        onPressed: () {
          Provider.of<CafeService>(context, listen: false).toggleFavorite(cafe.id);
        },
      ),
      onTap: () {
        // Aquí puedes implementar la navegación a una pantalla de detalles de la cafetería
      },
    );
  }
}
