import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/components/user_tile.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    refreshPage();
  }

  void refreshPage() {
    setState(() {
      _buildUserList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('H O M E'),
        centerTitle: true,
        foregroundColor: Colors.grey,
        actions: [
          IconButton(
            onPressed: refreshPage,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(context),
    );
  }

  Widget _buildUserList(context) {
    return StreamBuilder(
      stream: _chatService.getUsersStreamExcludingBlocked(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userdata, BuildContext context) {
    if (userdata['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userdata['firstName'],
        receiverId: userdata['uid'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverId: userdata['uid'],
                receiverName: userdata['firstName'],
                receiverEmail: userdata['email'],
                // senderName: userdata[],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
