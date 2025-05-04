import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/chatPage/AssistantMessageModel.dart';
import 'package:flutter_frontend/pages/chatPage/AssistantResponseProvider.dart';
import 'package:flutter_frontend/pages/chatPage/ChatScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatState();
}

class ChatState extends State<Chat> {
  List<AssistantMessage> chatHistory = [];
  List<Map<String, dynamic>> sessionsList = [];
  String? sessionId; // или sessionsList[0]["id"] по умолчанию
  bool isEmtySessionsList = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllSessions();
    // loadChatHistory();
  }

  void initializeNewChat() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('M/d/yyyy').format(now); // 👉 формат "4/28/2025"

    // Если нет сессий — создать новую
    String? newId = await AssistantResponseProvider.initializeSession();
    if (newId != null) {
      setState(() {
        sessionId = newId;
        isEmtySessionsList = false;
        sessionsList.add({"id": newId, "createdAt": formattedDate});
      });
    }
  }
  void loadAllSessions() async {
    List<Map<String, dynamic>>? data = await AssistantResponseProvider.getAllSessions();
    if (data != null && data.isNotEmpty) {
      setState(() {
        sessionsList = data;
        sessionId = data[data.length - 1]["id"];
        isEmtySessionsList = false;
      });
    } else {
      final now = DateTime.now();
      final formattedDate = DateFormat('M/d/yyyy').format(now); // 👉 формат "4/28/2025"

      // Если нет сессий — создать новую
      String? newId = await AssistantResponseProvider.initializeSession();
      if (newId != null) {
        setState(() {
          sessionId = newId;
          isEmtySessionsList = false;
          sessionsList = [{"id": newId, "createdAt": formattedDate}];
        });
      }
    }
  }

  void deleteAllSessions() async{
    bool success = await AssistantResponseProvider.deleteAllSessions();
    if(success){
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chat list',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          initializeNewChat();
                        },
                        icon: Icon(Icons.mode_edit_outline_sharp, color: Colors.black, size: 20),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ...sessionsList.map((session) {
                  String currentId = session["id"];
                  bool isSelected = currentId == sessionId;
                  int index = sessionsList.indexOf(session);

                  return Container(
                    color: isSelected ? Colors.blue.shade50 : Colors.transparent,
                    child: ListTile(
                      title: Text(
                        "Chat ${index + 1}",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        session["createdAt"],
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          sessionId = currentId;
                        });
                      },
                    ),
                  );
                }).toList(),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                  deleteAllSessions();
                }, child: Text("Delete all sessions", style:  GoogleFonts.poppins(
                  color: Colors.red,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),))
              ],
            ),
          ),
        ),
        appBar: AppBar(
        title: Text(
          "AI chatbot",
          style: GoogleFonts.poppins(
            fontSize: 18,
          ),
        ),
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Builder(
          // 👈 нужен Builder для доступа к Scaffold.of(context)
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // 👈 открывает Drawer
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context); // или logout / переход на главную
            },
          ),
        ],
      ),
        body:  sessionId == null
            ? Center(child: CircularProgressIndicator())
            : ChatScreen(
          key: ValueKey(sessionId),
          sessionId: sessionId,
        ),
    );
  }
}
