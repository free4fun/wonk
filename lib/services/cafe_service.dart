import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/cafe.dart';

class CafeService {
  List<Cafe> _cafes = [  ];
  List<Cafe> get cafes => _cafes;
  List<Cafe> get favoriteCafes => _cafes.where((cafe) => cafe.isFavorite).toList();

  Future<List<Cafe>> getCafes() async {
    // Simulamos una llamada asíncrona
    await Future.delayed(Duration(milliseconds: 500));
    return _cafes;
  }
  Future<void> addCafe(Cafe cafe) async {

  }
  Future<void> toggleFavorite(String id) async {
    final index = _cafes.indexWhere((cafe) => cafe.id == id);
    if (index != -1) {
      _cafes[index].isFavorite = !_cafes[index].isFavorite;
    }
  }
}
