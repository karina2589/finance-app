import 'dart:convert';
import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Saving.dart';

class Savings {
  final List<Saving> savings;

  Savings({required this.savings});

  factory Savings.fromJson(List<dynamic> jsonList) {
    List<Saving> savingsList =
    jsonList.map((json) => Saving.fromJson(json)).toList();
    return Savings(savings: savingsList);
  }

  static Future<List<Saving>?> fetchSavings() async {
    final Uri url = Uri.parse(AppConfig.savingsEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
    try {
      final response = await http.get(url, headers: {
        'user-id': userId,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        //  print("savings ${response.body}");
        Map<String, dynamic> savingsData = jsonDecode(response.body);
        List<dynamic> savingsList = savingsData['savings'] as List<dynamic>;
        return savingsList.map((saving) => Saving.fromJson(saving)).toList();
      }
    } catch (e) {
      print("fetch savings error $e");
    }
  }

  }

  static Future<bool> addSavings(Map<String, dynamic> newSaving) async {
    bool success = false;
    final Uri url = Uri.parse(AppConfig.savingsEndPoint);

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if(userId!=null){
      try {
        String? formattedDate = newSaving['dueDate'] != null
            ? DateTime.parse(newSaving['dueDate']).toUtc().toIso8601String()
            : null;

        final requestBody = {
          "title": newSaving['title'],
          "description": newSaving['description'],
          "targetAmount": newSaving['targetAmount'] ?? 0,
          "dueDate": formattedDate,
        };

        print("Request JSON: ${jsonEncode(requestBody)}"); // Лог запроса

        final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'user-id': userId,
            },
            body: jsonEncode(requestBody)
        );
        if (response.statusCode == 200) {
          success = true;
          print("savinds goal created");
          print(response.body);
        }else{
          print("Failed to add goal ${response.body}");
        }

      } catch (e) {
        success = false;
        print("problem with creating savings ${e}");
      }

    }
    return success;
  }

  static Future<bool> deleteSaving(int id) async{
    bool success = false;
    final String url = "${AppConfig.savingsEndPoint}/$id";

    try{
      final response = await http.delete(Uri.parse(url),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        success = true; // Successfully deleted
      } else {
        print("Failed to delete saving: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error deleting saving: $e");
      success = false;
    }

    return success;
    }

    static Future<bool> updateSaving(Map<String, dynamic> updatedSaving, int id) async{
      bool success = false;
      final String url = "${AppConfig.savingsEndPoint}/$id";
      Map<String, dynamic> filteredSaving = updatedSaving..removeWhere((key, value) => value == null);

      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      if(userId!=null) {
        try {
          final response = await http.put(
            Uri.parse(url),
            headers: {
              'user-id': userId,
              'Content-Type': 'application/json',
            },
            body: jsonEncode(filteredSaving),
          );

          if (response.statusCode == 200) {
            success = true;
          } else {
            print("problem with updating saving");
            print(response.body);
            success = false;
          }
        } catch (e) {
          print("Error updating expense: $e");
          success = false;
        }
      }

      return success;
    }
}



void main() async {
  Map<String, dynamic> newSaving = {'title': 'updated'};
  bool success = await Savings.updateSaving(newSaving,4);
  print(success);
  List<Saving>? savings = await Savings.fetchSavings();
if(savings!= null) {
  for (var saving in savings) {
    print(saving.title);
    print(saving.id);
    print(saving.dueDate);
  }
}

}
