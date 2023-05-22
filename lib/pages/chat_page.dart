import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

import '../consts.dart';
import '../models/message_model.dart';
import '../utils/app_theme.dart';
import '../utils/remove_message_extra_char.dart';
import '../widgets/chat_message_list_widget.dart';
import '../widgets/chat_type_message_widget.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  const ChatPage(this.userName, {Key? key}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    openSignalRConnection();
    createRandomId();
  }

  int currentUserId = 0;
  //generate random user id
  createRandomId() {
    Random random = Random();
    currentUserId = random.nextInt(999999);
  }

  ScrollController chatListScrollController = ScrollController();
  TextEditingController messageTextController = TextEditingController();
  submitMessageFunction() async {
    if (connection.state == HubConnectionState.disconnected) {
      await openSignalRConnection();
    }
    if (connection.state != HubConnectionState.connected) {
      return;
    }
    var messageText = removeMessageExtraChar(messageTextController.text);
    if (messageText.isEmpty) {
      return;
    }
    await connection.invoke('SendMessage',
        args: [widget.userName, currentUserId, messageText]);
    messageTextController.text = "";
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat room', style: AppTheme.loginSubTitleTitleStyle),
        backgroundColor: AppTheme.gradientColorFrom,
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            // chatAppbarWidget(size, context),
            chatMessageWidget(
                chatListScrollController, messageModel, currentUserId),
            chatTypeMessageWidget(messageTextController, submitMessageFunction)
          ],
        ),
      ),
    );
  }

  //set url and configs
  final connection = HubConnectionBuilder()
      .withUrl(
          '$baseUrl/$chatHub',
          HttpConnectionOptions(
            logging: (level, message) {
              debugPrint("level: $level, message: $message");
            },
            logMessageContent: true,
            accessTokenFactory: () async {
              await Future.delayed(const Duration(seconds: 1));
              return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6IjEwMSIsIkVtYWlsIjpbInRhbXRob2lkZXRyb25nQGdtYWlsLmNvbSIsInRhbXRob2lkZXRyb25nQGdtYWlsLmNvbSJdLCJuYW1lIjoidGFtdGhvaWRldHJvbmdAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVHJhaW5lZSIsImV4cCI6MTY4NDY4MzQ5MywiaXNzIjoidHJhaW5pbmdtYW5hZ2VtZW50c3lzdGVtLmF6dXJld2Vic2l0ZXMubmV0IiwiYXVkIjoidHJhaW5pbmdtYW5hZ2VtZW50c3lzdGVtLmF6dXJld2Vic2l0ZXMubmV0In0.cRylx71oZWM6BHjW_ymwViPslzq8QfQxPNeYb0_Jc-k";
            },
          ))
      .build();

  //connect to signalR
  Future<void> openSignalRConnection() async {
    await connection.start();
    connection.on('ReceiveMessage', (message) {
      _handleIncommingDriverLocation(message);
    });
    await connection.invoke('JoinUSer', args: [widget.userName, currentUserId]);
  }

  //get messages
  List<MessageModel> messageModel = [];
  Future<void> _handleIncommingDriverLocation(List<dynamic>? args) async {
    if (args != null) {
      var jsonResponse = json.decode(json.encode(args[0]));
      MessageModel data = MessageModel.fromJson(jsonResponse);
      setState(() {
        messageModel.add(data);
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    chatListScrollController.animateTo(
      chatListScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
