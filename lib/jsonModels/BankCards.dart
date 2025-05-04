import 'dart:convert';

import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'BankCard.dart';

class BankCards{
  final List<BankCard> cards;

  BankCards({required this.cards});
  
  factory BankCards.fromJson(List<dynamic> jsonList){
    List<BankCard> cardsList = jsonList.map((json) => BankCard.fromJson(json)).toList();
    return BankCards(cards: cardsList);
  }
  
  static Future<List<BankCard>?> fetchCards() async{
    final Uri url = Uri.parse(AppConfig.cardsEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      try{
        final response = await http.get(url,
            headers: {
              'user-id': userId,
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            });
        if(response.statusCode == 200){
          List<dynamic> cardsData = jsonDecode(response.body);
          print(response.body);
          return cardsData.map((card) => BankCard.fromJson(card)).toList();

        }else{
          print("fetching cards error ${response.body}");
        }
      }catch(e){
        print("fetching cards exception $e");
      }
    }
  }

  static Future<bool> addCard(String cardName) async{
    final Uri url = Uri.parse(AppConfig.cardsEndPoint);
    bool success = false;

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      try {
        final response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'user-id': userId,
            },
            body: jsonEncode({
              "title": cardName
            }));

        if (response.statusCode == 200) {
          success = true;
          print("card added successfully");
        } else {
          print("problem with adding new card ${response.body}");
        }
      } catch (e) {
        print("error with adding new card $e");
      }

    }
    return success;
  }

  static Future<bool> deleteCard(int id) async{
    bool success = false;
    String url = "${AppConfig.cardsEndPoint}/$id";

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      try{
        final response = await http.delete(Uri.parse(url),
            headers: {
              'user-id': userId,
              'Content-Type': 'application/json',
            }
        );
        if(response.statusCode == 200){
          success = true;
          print("card deleted successfully!");
        }else{
          print("deleting card error ${response.body}");
        }
      }catch(e){
        print("deleting card exception $e");
      }
    }
    return success;
  }

  static Future<bool> updateCard(String updatedCardName, int id) async{
    bool success = false;
    String url = "${AppConfig.cardsEndPoint}/$id";

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      try{
        final response = await http.put(Uri.parse(url),
            headers: {
              'user-id': userId,
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "title": updatedCardName
            })
        );
        if(response.statusCode == 200){
          success = true;
          print("card update successfully!");
        }else{
          print("updating card error ${response.body}");
        }
      }catch(e){
        print("updating card exception $e");
      }
    }
    return success;
  }
}

void main() async{
 // bool success = await BankCards.updateCard("Halyk",14);
 // if(success){
   List<BankCard>? cards = await BankCards.fetchCards();
   if(cards != null){
     for( var card in cards){
       print(card.id);
       print(card.title);
       //print(card.incomes);
     }
  // }
 }
}