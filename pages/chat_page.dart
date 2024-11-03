import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/text_field.dart';
import 'package:chatapp/pages/chat_settings.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String receiverName;
  final String receiverId;
  final String receiverEmail;

  const ChatPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverEmail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  final ScrollController _scrollController = ScrollController();

  ValueNotifier<String> replyMessage = ValueNotifier<String>('');

  FocusNode myFocusNode = FocusNode();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatService.dispose();
    _scrollController.dispose();
    replyMessage.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(
      () {
        if (myFocusNode.hasFocus) {
          Future.delayed(
            const Duration(milliseconds: 300),
            () => scrollDown(),
          );
        }
      },
    );

    Future.delayed(
      const Duration(milliseconds: 300),
      () => scrollDown(),
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverId,
        _messageController.text,
        replyMessage.value,
      );
    }
    replyMessage.value = '';
    _messageController.clear();
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        scrollDown();
      },
    );
  }

  void onReply(message) {
    replyMessage.value = message;
    Future.delayed(
      const Duration(milliseconds: 200),
      () => scrollDown(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatSettings(
                  receiverName: widget.receiverName,
                  receiverId: widget.receiverId,
                  receiverEmail: widget.receiverEmail,
                  friend: true,
                ),
              ),
            );
          },
          child: Text(widget.receiverName),
        ),
        centerTitle: true,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          userInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderId, widget.receiverId),
      builder: (context, snaphot) {
        if (snaphot.hasError) {
          return const Text("Error");
        }

        if (snaphot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(10),
          children:
              snaphot.data!.docs.map((doc) => buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    final ChatBubble chatBubble = ChatBubble(
      message: data['message'],
      isCurrentUser: isCurrentUser,
      messageId: doc.id,
      userId: data['senderId'],
      onReply: () => onReply(data['message']),
      replyMessage: data['replyMessage'],
      receiverId: widget.receiverId,
    );

    Timestamp time = data['timestamp'];
    int timestamp = time.millisecondsSinceEpoch;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat('kk:mm').format(date);

    return Column(
      children: [
        Container(
          alignment: alignment,
          child: chatBubble,
        ),
        Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(formattedDate),
          ],
        )
      ],
    );
  }

  Widget userInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: replyMessage,
            builder: (context, value, child) {
              return Column(
                children: [
                  replyMessage.value != ''
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                child: Text(replyMessage.value),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  replyMessage.value = '';
                                },
                                icon: const Icon(Icons.cancel))
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hinTtext: 'Type a message',
                          textEditingController: _messageController,
                          type: 'email',
                          obscure: false,
                          focusNode: myFocusNode,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          onPressed: sendMessage,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
