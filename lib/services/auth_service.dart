import 'package:flutter/foundation.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  late Auth0 _auth0;
  User? _user;
  String? _token;
  final String? _backendUrl = dotenv.env['BACKEND_URL'];
  bool get isAuthenticated => _user != null; //Solo es un simulacro. FIXME.


  User? get user => _user;
  String? get token => _token;

  AuthService() {
    final domain = dotenv.env['AUTH0_DOMAIN'];
    final clientId = dotenv.env['AUTH0_CLIENT_ID'];
    if (domain != null && clientId != null) {
      _auth0 = Auth0(domain, clientId);
    } else {
      print('Error: AUTH0_DOMAIN or AUTH0_CLIENT_ID is null');
    }
  }

Future<void> simulateLogin() async {
    // Simular un usuario autenticado
    _user = User(
      id: 'simulated_id',
      name: 'Usuario Simulado',
      email: 'usuario@simulado.com',
    );
    _token = 'simulated_token';
    notifyListeners();
  }

  Future<void> loginWithAuth0() async {
    try {
      final credentials = await _auth0.webAuthentication().login();
      _token = credentials.accessToken;
      await _getUserInfo();
      notifyListeners();
    } catch (e) {
      print('Error durante el inicio de sesión con Auth0: $e');
      rethrow;
    }
  }

  Future<void> registerWithBackend(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final userData = jsonDecode(response.body);
        _user = User.fromJson(userData);
        _token = userData['token'];
        notifyListeners();
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      print('Error durante el registro: $e');
      rethrow;
    }
  }

  Future<void> loginWithBackend(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        _user = User.fromJson(userData);
        _token = userData['token'];
        notifyListeners();
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print('Error durante el inicio de sesión: $e');
      rethrow;
    }
  }

  Future<void> _getUserInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$_backendUrl/auth/user'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        _user = User.fromJson(userData);
        notifyListeners();
      } else {
        throw Exception('Failed to get user info: ${response.body}');
      }
    } catch (e) {
      print('Error al obtener información del usuario: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth0.webAuthentication().logout();
      _user = null;
      _token = null;
      notifyListeners();
    } catch (e) {
      print('Error durante el cierre de sesión: $e');
      rethrow;
    }
  }
}
