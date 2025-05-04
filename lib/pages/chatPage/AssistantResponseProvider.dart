import 'dart:convert';
import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:flutter_frontend/pages/chatPage/AssistantMessageModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AssistantResponseProvider{

  static Future<String?> initializeSession() async{
    final url = Uri.parse(AppConfig.initializeChatSession);
    bool success = false;
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      try{
        final response = await http.get(url,
        headers: {
          'user-id': userId,
          // 'user-id': "2cbbbf55-81f0-4475-8fe0-e29c664b6aa3",
          // 'user-id': userId,
          'Content-Type': 'application/json',
        });

        if(response.statusCode == 200){
           Map<String, dynamic> data =jsonDecode(response.body);
           String sessionId = data['sessionId'];
           // success = true;
           print(sessionId);
           return sessionId;
           // await prefs.setString('sessionId', sessionId);
        }
      }catch(e){
        print("error initializing chat");
      }
    }
  }
  
  static Future<bool> deleteAllSessions() async{
    final url = Uri.parse(AppConfig.chatSessionsEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    bool success = false;

    if(userId != null){
      try{
        final response = await http.delete(url,
            headers: {
              'user-id': userId,
              'Content-Type': 'application/json',
            },
        );
        if(response.statusCode==200){
          success = true;
          print("sessions deleted successfully!");
        }
      }catch(e){
        print("can't send message $e");
      }
    }
    return success;
  }

  static Future<AssistantMessage?> sendMessage(String message, String sessionId) async{
    final url = Uri.parse(AppConfig.sendMessageEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    // String? sessionId = prefs.getString('sessionId');

    if(userId != null && sessionId != null){
      Map<String, dynamic> mess = {
        "sessionId": sessionId,
        "message": message
      };
      try{
        final response = await http.post(url,
            headers: {
               'user-id': userId,
              // 'user-id': "2cbbbf55-81f0-4475-8fe0-e29c664b6aa3",
              // 'user-id': userId,
              'Content-Type': 'application/json',
            },
          body: jsonEncode(mess)
            );
        if(response.statusCode==200){
          Map<String, dynamic> data = jsonDecode(response.body);
          Map<String, dynamic> answer = data['assistantMessage'];
          // print(answer);
          return AssistantMessage.fromJson(answer);
        }
      }catch(e){
        print("can't send message $e");
      }
    }
  }

  //TODO: insights should be changed into POST or move bdy to headers
static Future<AssistantMessage?> getInsights(String sessionId) async{
    final url =  Uri.parse(AppConfig.assistantInsightsEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    // String? sessionId = prefs.getString('sessionId');

    if(userId != null && sessionId != null){
    Map<String, dynamic> mess = {
      "sessionId": "cma0mjxv10009lo2oxm8k296h",
    };
    try{
      final response = await http.get(url,
          headers: {
            'user-id': userId,
            // 'user-id': "2cbbbf55-81f0-4475-8fe0-e29c664b6aa3",
            // 'user-id': userId,
            'Content-Type': 'application/json',
          },
          // body: jsonEncode(mess)
      );
      if(response.statusCode==200){
        Map<String, dynamic> data = jsonDecode(response.body);
        Map<String, dynamic> answer = data['assistantMessage'];
        print(answer);
        return AssistantMessage.fromJson(answer);
      }else{
        print(response.body);
      }
    }catch(e){
      print("can't send message $e");
    }
  }
}

//TODO: get all messages form exact chat session
 static Future<List<AssistantMessage>?> getSessionMessages(String sessionId) async{
    final url = Uri.parse("${AppConfig.chatMessagesEndPoint}/$sessionId");
   final prefs = await SharedPreferences.getInstance();
   String? userId = prefs.getString('userId');
   // String? sessionId = prefs.getString('sessionId');

    if(userId != null && sessionId != null){
    try{
      final response = await http.get(url,
        headers: {
          'user-id': userId,
          // 'user-id': "2cbbbf55-81f0-4475-8fe0-e29c664b6aa3",
          // 'user-id': userId,
          'Content-Type': 'application/json',
        },
      );
      if(response.statusCode==200){
        List<dynamic> json = jsonDecode(response.body);
        // List<ChatMessageModel> messages = json.map((item) => ChatMessageModel.fromJson(item)).toList();
        return json.map((item) => AssistantMessage.fromJson(item)).toList();
      }else{
        print("smt wrong with fetching messages ${response.body}");
      }
    }catch(e){
      print("can't send message $e");
    }
   }

 }

//TODO: get list of all sessions
static Future<List<Map<String, dynamic>>?> getAllSessions() async{
    final url = Uri.parse(AppConfig.chatSessionsEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    // String? sessionId = prefs.getString('sessionId');

    if(userId != null){
    try{
      final response = await http.get(url,
        headers: {
          'user-id': userId,
          // 'user-id': "2cbbbf55-81f0-4475-8fe0-e29c664b6aa3",
          // 'user-id': userId,
          'Content-Type': 'application/json',
        },
      );
      if(response.statusCode==200){
        // print(response.body);
        List<dynamic> data = jsonDecode(response.body);

        // Преобразуй каждый элемент в Map<String, dynamic>
        List<Map<String, dynamic>> sessions = data
            .map((item) => item as Map<String, dynamic>)
            .toList();

        return sessions;

      }else{
        print(response.body);
      }
    }catch(e){
      print("can't send message $e");
    }
  }

}
}

void main() async{
  // bool success = await AssistantResponseProvider.initializeSession();
  // if(success){
  //   print("horray");
  // }
  List<Map<String, dynamic>>? answer  = await AssistantResponseProvider.getAllSessions();
  if(answer!=null){
    for(var i in answer){
      print(i['id']);
      print(i['createdAt']);
    }
  }
}