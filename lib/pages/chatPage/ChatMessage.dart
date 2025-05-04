// class ChatMessage {
//   final String content;
//   final bool isUser;
//
//   ChatMessage({required this.content, required this.isUser});
// }

class ChatMessage{
  final String content;
  final String role;

  ChatMessage({
    required this.role,
    required this.content,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json){
    return ChatMessage(
        role: json['role'],
        content: json['content']);
  }
}