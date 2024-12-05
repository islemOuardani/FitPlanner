import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:fit_planner/controllers/user_controller.dart';
import 'package:flutter/material.dart';


import '../../controllers/ai_service.dart';


class ChatPage extends StatefulWidget{
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {

  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id:UserController.user.toString() , firstName: UserController.user?.displayName ?? "", profileImage: UserController.user?.photoURL ?? '');
  ChatUser chatUser = ChatUser(id: "1", firstName: "ChatBot", profileImage: "assets/photos/icon.png");
  final TextEditingController _controller = TextEditingController();
  final AIChatService _aiChatService = AIChatService();

  @override
  void initState() {
    super.initState();
    ChatMessage initialMessage = ChatMessage(
      user: chatUser,
      text: "Hello ${currentUser.firstName}, how can I assist you today?",
      createdAt: DateTime.now(),
    );
    setState(() {
      messages.add(initialMessage);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Personal coach",
        ),
      ),
      body: _buildUI(),
    );
  }
  Widget _buildUI(){
    return DashChat(
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      //final content = Content.text(chatMessage.text);
      final response = await _aiChatService.sendMessage(chatMessage.text);
      print(response);
      if (response.isNotEmpty) {
        final botMessage = ChatMessage(
          text: response,
          user: chatUser,
          createdAt: DateTime.now(),
        );
        setState(() {
          messages = [botMessage, ...messages];
        });
      }
    } catch (e) {
      print("Error: $e");
      final errorMessage = ChatMessage(
        text: "An error occurred while generating a response. Please try again.",
        user: chatUser,
        createdAt: DateTime.now(),
      );
      setState(() {
        messages = [errorMessage, ...messages];
      });
    }
  }

}