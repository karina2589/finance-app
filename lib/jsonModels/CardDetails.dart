import 'dart:convert';

import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:flutter_frontend/jsonModels/CardDetail.dart';
import "package:http/http.dart" as http;

class CardDetails{
  final List<CardDetail> details;

  CardDetails({required this.details});

  factory CardDetails.fromJson(List<dynamic> jsonList){
    List<CardDetail>? cardData = jsonList.map((json) => CardDetail.fromJson(json)).toList();
    return CardDetails(details: cardData);
  }
  
  static Future<List<CardDetail>?> fetchCardsDetails() async{
    final Uri url = Uri.parse(AppConfig.cardsDetailsEndPoint);
    
    try{
      final response = await http.get(url,
          headers: {
            'user-id': '2cbbbf55-81f0-4475-8fe0-e29c664b6aa3',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          }
      );
      if(response.statusCode == 200){
        List<dynamic> detailsData = jsonDecode(response.body);
        return detailsData.map((detail) => CardDetail.fromJson(detail)).toList();
      }else{
        print("error with fetching card details ${response.body}");
      }
    }catch(e){
      print("fetching card details exception $e");
    }
  }
}

void main() async{
  List<CardDetail>? details = await CardDetails.fetchCardsDetails();
  if(details!=null){
    for(var detail in details){
      print(detail.id);
      print(detail.title);
      print(detail.balance);
    }
  }
}