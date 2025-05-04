import 'package:flutter/foundation.dart';
import 'package:flutter_frontend/config/AppConfig.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class User {
  /*
  {
  "fullname": "Bushra Aksoy",
  "username": "bushraaksoy",
  "email": "bbxsra17@gmail.com",
  "dob": "7/17/2003",
  "gender": "FEMALE"
}
   */
  final String? fullname;
  final String username;
  final String? email;
  final String? dob;
  final String? gender;

  User({
    required this.fullname,
    required this.email,
    required this.dob,
    required this.gender,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // DateTime? parsedDob;
    // if (json['dob'] != null) {
    //   try {
    //     // Попробуем сначала стандартный формат
    //     parsedDob = DateTime.parse(json['dob']); // YYYY-MM-DD
    //   } catch (e) {
    //     try {
    //       // Если не получилось, попробуем MM-DD-YYYY
    //       final DateFormat format = DateFormat("MM-dd-yyyy");
    //       parsedDob = format.parse(json['dob']);
    //     } catch (e) {
    //       print("Ошибка преобразования даты: ${json['dob']}");
    //     }
    //   }
    // }

    return User(
      fullname: json['fullname'],
      username: json['username'],
      email: json['email'],
      dob: json['dob'],
      gender: json['gender'],
    );
  }

  static Future<User?> fetchData() async {
    final url = Uri.parse(AppConfig.profileEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print("userId $userId");

    if (userId != null) {
      try {
        final response = await http.get(
          url,
          headers: {
            // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // If using authentication
            'User-ID': userId,
            // Adding User-ID in the header
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return User.fromJson(data);
        } else {
          print('error: ${response.statusCode}');
        }
      } catch (e) {
        print(e);
      }
    }
    return null;
  }


  static Future<String> updateUserData({
    required  String? fullname,
    required  String? username,
    required  String? email,
    required  String? dob,
    required  String? gender,

  }) async {
    final Uri url = Uri.parse(AppConfig.profileEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    Map<String, dynamic> body = {};

    if (username != null) body["username"] = username;
    if (email != null) body["email"] = email;
    if (fullname != null) body["fullname"] = fullname;
    if (dob != null) body["dob"] = dob;
    if (gender != null) body["gender"] = gender; // null не будет добавляться

    if (body.isNotEmpty && userId!=null) {
      try {
        final http.Response res = await http.put(
          url,
          headers: {
            "user-id" :userId,
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: jsonEncode(body), // Отправляем только изменённые поля
        );

        if (res.statusCode == 200) {
          return "Successfully updated";
        } else {
          print("Error: ${res.statusCode}, ${res.body}");
          return "Can't update info. Please check your connection";
        }
      } catch (e) {
        print("Network error: $e");
        return "Can't update info. Please check your connection";
      }
    }
    return "body is empty";
  }
}

//
//   void main() async {
//     User? user = await User.fetchDataTest();
//     if (user != null) {
//       print('Full Name: ${user.fullname}');
//       print('Username: ${user.username}');
//       print('Email: ${user.email}');
//       print('Date of Birth: ${user.dob}');
//       print('Gender: ${user.gender}');
//     } else {
//       print('Failed to fetch user data.');
//     }
//
//     // String? dob = user?.dob;
//     //
//     // if (dob != null) {
//     //   DateTime parsedDate = DateFormat("M/d/yyyy").parse(dob);
//     //   print(parsedDate);
//     // } else {
//     //   print("Дата рождения отсутствует");
//     // }
//    // User.updateUserData(fullname: null, username: null, email: "hubabuba@buba.com", dob: null, gender: "FEMALE");
//
// }
