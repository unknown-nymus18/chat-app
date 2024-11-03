// import 'package:chatapp/components/user_tile.dart';
import 'package:chatapp/components/profile_picture.dart';
import 'package:chatapp/pages/chat_settings.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  TextEditingController searchController = TextEditingController();

  // ValueNotifier<List<List<String>>> results =
  //     ValueNotifier<List<List<String>>>([]);

  void searchUsers(value) {
    setState(() {
      _buildUserList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S E A R C H'),
        centerTitle: true,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            child: CustomSearchbar(
              controller: searchController,
              onSubmit: (value) => searchUsers(value),
            ),
          ),
          // ValueListenableBuilder(
          //   valueListenable: results,
          //   builder: (context, value, child) {
          //     return ListView.builder(
          //       itemCount: results.value.length,
          //       itemBuilder: (context, index) {
          //         return ListTile(title: Text(results.value[index][0]));
          //       },
          //     );
          //   },
          // ),
          Expanded(child: _buildUserList(context)),
        ],
      ),
    );
  }

  Widget _buildUserList(context) {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("An error has occured."));
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
      if (searchController.text.isNotEmpty) {
        if (userdata['firstName']
            .toString()
            .toLowerCase()
            .contains(searchController.text.toLowerCase())) {
          return ListTile(
            leading: ProfilePicture(size: 50, userId: userdata['uid']),
            title: Text(
              userdata['firstName'],
              style: const TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatSettings(
                    receiverId: userdata['uid'],
                    receiverName: userdata['firstName'],
                    receiverEmail: userdata['email'],
                    friend: false,
                  ),
                ),
              );
            },
            horizontalTitleGap: 30,
          );
        } else {
          return Container();
        }
      } else {
        return ListTile(
          leading: ProfilePicture(size: 50, userId: userdata['uid']),
          title: Text(
            userdata['firstName'],
            style: const TextStyle(fontSize: 18),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatSettings(
                  receiverId: userdata['uid'],
                  receiverName: userdata['firstName'],
                  receiverEmail: userdata['email'],
                  friend: false,
                ),
              ),
            );
          },
          horizontalTitleGap: 30,
        );
      }
    } else {
      return const Center(
        child: Text("No results found"),
      );
    }
  }
}

class CustomSearchbar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value) onSubmit;
  const CustomSearchbar({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => onSubmit(value),
              onSubmitted: (value) => onSubmit(value),
              controller: controller,
              cursorColor: Theme.of(context).colorScheme.surface,
              autofocus: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                hintText: 'Search',
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              controller.clear();
              onSubmit;
            },
            icon: const Icon(Icons.clear),
          )
        ],
      ),
    );
  }
}
