class ChatMessageModel {
  /*
   "id": "cma0mkcwc000dlo2ojyhsih4v",
        "createdAt": "2025-04-28T05:15:34.861Z",
        "role": "user",
        "content": "Hello",
        "sessionId": "cma0mjxv10009lo2oxm8k296h"
   */
  // final String id;
  // final String createdAt;
  final String role;
  final String content;
  // final String sessionId;

  ChatMessageModel({
    // required this.id,
    // required this.createdAt,
    required this.role,
    required this.content,
    // required this.sessionId
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json){
    return ChatMessageModel(
        // id: json['id'],
        // createdAt: json['createdAt'],
        role: json['role'],
        content: json['content']);
        // sessionId: json['sessionId']);
  }
}