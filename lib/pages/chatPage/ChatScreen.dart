import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AssistantMessageModel.dart';
import 'AssistantResponseProvider.dart';

class ChatScreen extends StatefulWidget{
  final String? sessionId;
  ChatScreen({ Key? key, this.sessionId});
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>{
  final _controller = TextEditingController();
  List<AssistantMessage> chatHistory = [];
  List<Map<String, dynamic>> sessionsList = [];
  String? session;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    session = widget.sessionId;

    // Если session не передали — инициализируем новую
    if (session == null) {
      initializeNewChat();
    } else {
      loadChatHistory(session!);
    }
  }

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sessionId != widget.sessionId) {
      _updateChat();
    }
  }

  void _updateChat() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(milliseconds: 600));
    session = widget.sessionId;
    loadChatHistory(session!); // 💡 добавить это
  }

  void initializeNewChat() async {
    String? newSessionId = await AssistantResponseProvider.initializeSession();
    if (newSessionId!=null) {
      // Предположим, ты можешь получить ID новой сессии:
      setState(() {
        session = newSessionId;
      });
      loadChatHistory(session!); // если надо
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // 1. Добавить сообщение пользователя сразу
    setState(() {
      chatHistory.add(AssistantMessage(role: 'user', content: message));
      // isLoading = true;
    });

    _controller.clear();

    // 2. Получить ответ ассистента
    AssistantMessage? response = await AssistantResponseProvider.sendMessage(
        message, session!);

    if (response != null) {
      setState(() {
        chatHistory.add(response);
        // isLoading = false;
      });
    }
  }


  void loadChatHistory(String sessionId) async {
    List<AssistantMessage>? data =
    await AssistantResponseProvider.getSessionMessages(
        sessionId);
    if (data != null) {
      setState(() {
        chatHistory = data;
        print("CHAT HISTORY");
        print(chatHistory);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading?
    Center(
      child: CircularProgressIndicator(),
    ):
    Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: chatHistory.length,
            itemBuilder: (context, index) {
              final msg = chatHistory[index];
              return Align(
                alignment: msg.role == 'user'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: msg.role == 'user'
                        ? Colors.blueAccent
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: MarkdownBody(
                    data: msg.content ?? '',
                    styleSheet: MarkdownStyleSheet(
                      p: GoogleFonts.poppins(
                        fontSize: 15,
                        color:
                        msg.role == 'user' ? Colors.white : Colors.black,
                      ),
                      h3: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: GoogleFonts.poppins(fontSize: 16),
                  controller: _controller,
                  onSubmitted: (value) {
                    sendMessage(value); // или динамический sessionId
                    _controller.clear();
                  },
                  decoration: const InputDecoration.collapsed(
                    hintText: "ask question",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  sendMessage(_controller.text, );
                  _controller.clear();
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}