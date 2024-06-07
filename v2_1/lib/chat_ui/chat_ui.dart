import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:v2_1/home_screen/components/create_new_project.dart';

class chatPage extends StatefulWidget {
  const chatPage({super.key, required this.questions, required this.answers, required this.title, required this.pageName});
  final Map<String, List<String>> questions; final Map<String, String> answers; final String title;
  final String pageName;


  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  bool _questionAnswered = false;
  Map<String, String> userAnswer = {};
  final _user = const types.User(
    id: 'currentUser',
    role: types.Role.user,
  );
  final _comfyHelper = const types.User(
      id: 'comfyHelper',
      role: types.Role.admin,
      imageUrl: 'https://comfystudio.tech/chilling-in-the-park.jpg'
  );
  List<types.Message> _messages = [];

  @override
  void initState() {
    _conversationSequence();
    super.initState();
  }

  Future<void> _conversationSequence() async{
    //Loop through the map of conversation
    Map<String, List<String>> questionMap = widget.questions;
    for(var title in questionMap.keys) {
      List<String> questions = questionMap[title]!;
      //Send all questions in the question
      await Future.delayed(Duration(milliseconds: 200));
      for (final question in questions){
        //Send each question one by one
        _sendAdminMessage(question);
        await Future.delayed(Duration(milliseconds: 200));
        print(question);
      }
      //await for response
      while (!_questionAnswered) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      //log response
      userAnswer[title] = _messages.first.toJson()['text'];
      print(userAnswer[title]);

      // Send confirmation message
      //_sendAdminMessage("$title is ${userAnswer[title]}, confirmed");

      //ask the next questions (continue loop)
    };
    if (kDebugMode) {
      print(userAnswer.toString());
    }
    _moveToNextPage();
  }
  void _moveToNextPage(){
   switch (widget.pageName){
     //If user are in "create a new project" & finished "picking name & description", move to pick image page
     case 'create_new_project_pick_name': Navigator.push(context, MaterialPageRoute(builder: (context) => pickProjectImage(project_name: userAnswer['project_name']!, project_description: userAnswer['project_description']!)));
   }
  }
  void _sendAdminMessage(String msg){
    final textMessage = types.TextMessage(
      author: _comfyHelper,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: msg,
    );
    setState(() {
      _messages.insert(0, textMessage);
      _questionAnswered = false;
    });
  }

  void _sendUserMessage(String msg){
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: msg,
    );
    setState(() {
      _messages.insert(0, textMessage);
      _questionAnswered = true;
    });
  }
  void _handleSendPressed(types.PartialText message) {
    _sendUserMessage(message.text);
    //_questionAnswered = true;
  }
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,

      ),
      body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
          showUserAvatars: true,
          theme: DefaultChatTheme(
              primaryColor: Theme.of(context).colorScheme.primary,
              secondaryColor:
              //Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              inputTextStyle: Theme.of(context).textTheme.bodyMedium!,
              inputTextColor: Theme.of(context).colorScheme.surface,
              receivedMessageBodyTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
              sentMessageBodyTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.surface),
              inputBackgroundColor: Theme.of(context).colorScheme.primary
          )
      ),
    );
  }
}