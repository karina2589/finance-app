import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/AppConfig.dart';

class StreamAuth {
  final int refreshInterval;
  final StreamController<String?> _userStreamController;

  //current user
  String? _currentUser;

  //final StreamAuth _auth;
  final String registerEndPoint = AppConfig.registrationendPoint;
  final String loginEndPoint = AppConfig.loginEndPoint;

  String? get currentUser => _currentUser;

  StreamAuth({this.refreshInterval = 20,}) :
        _userStreamController = StreamController<String?>.broadcast() {
    _userStreamController.stream.listen((String? currentUser) {
      _currentUser = currentUser;
    });
  }
  Future<bool> isSignedIn() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }

  Future<void> saveUserToken(String token, String user) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('userId', user);

    print('User logged in: $user');
    _userStreamController.add(token);
    _userStreamController.add(user);// Уведомляем подписчиков

  }

  Future<String?> getUserToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');

  }

  Future<void> logout() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _userStreamController.add(null); // Сообщаем подписчикам, что пользователь вышел

  }

  Future<void> loadCurrentUser() async {
    final token = await getUserToken(); // Получаем токен из SharedPreferences
    _currentUser = token; // Обновляем текущее состояние пользователя
    _userStreamController.add(_currentUser); // Уведомляем подписчиков стрима
  }


  Stream<String?> get onCurrentUserChanged => _userStreamController.stream;

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(loginEndPoint),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if(response.statusCode==200){
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      final user = data['userId'];

      //save token
       await saveUserToken(token, user);
      print('logging success');

     return "LoggedIn";
    }else{
      print('Login failed: ${response.body}');
      final errorMessage = jsonDecode(response.body);
      String message = errorMessage['message'];
      print(message);
      return message;
    }
  }

  Future<String> register(String username, String password) async{
    final response = await http.post(
      Uri.parse(registerEndPoint),
      headers:  {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if(response.statusCode==201){

      return "Registered";
    }else{
      print('Registration failed: ${response.body}');
      final errorMessage = jsonDecode(response.body);
      String message = errorMessage['message'];
      print(message);
      return message;
    }
  }




}