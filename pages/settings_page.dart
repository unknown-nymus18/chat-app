import 'package:chatapp/components/profile_picture.dart';
import 'package:chatapp/pages/blocked_users_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:chatapp/services/storage/image_storage.dart';
import 'package:chatapp/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final ImageStorage _imageStrorage = ImageStorage();
  ValueNotifier<String> imageSrc = ValueNotifier<String>('');

  void deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete account"),
        content: const Text("Do you want to delete the account"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              try {
                ChatService chatService = ChatService();
                chatService.deleteUser();
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString(),
                    ),
                  ),
                );
              }
            },
            child: const Text("Delete Account"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
        centerTitle: true,
        foregroundColor: Colors.grey,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: _profilePicture(),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: _firebaseFirestore
                .collection('Users')
                .doc(_authService.getCurrentUser()!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "User",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ));
              }
              var data = snapshot.data!.data() as Map<String, dynamic>;
              return Center(
                child: Text(
                  data['firstName'],
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Dark Mode"),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlockedUsersPage(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Blocked Users"),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => deleteAccount(context),
            child: Container(
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Delete Account"),
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profilePicture() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: ProfilePicture(
              size: 150, userId: _authService.getCurrentUser()!.uid),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              showDragHandle: true,
              enableDrag: true,
              context: context,
              builder: (context) {
                return SafeArea(
                  child: Wrap(
                    children: [
                      ListTile(
                        onTap: () async {
                          Navigator.pop(context);
                          imageSrc.value =
                              await _imageStrorage.uploadCameraPicture();
                          setState(() {});
                        },
                        title: const Text("Take photo"),
                        leading: const Icon(Icons.photo_camera),
                      ),
                      ListTile(
                        onTap: () async {
                          try {
                            Navigator.pop(context);
                            imageSrc.value = await _imageStrorage.uploadImage();
                            setState(() {});
                          } catch (e) {
                            throw e.toString();
                          }
                        },
                        title: const Text("Change photo"),
                        leading: const Icon(Icons.photo),
                      ),
                      ListTile(
                        onTap: () async {
                          Navigator.pop(context);
                          imageSrc.value = await _imageStrorage.deletePicture();
                          setState(() {});
                        },
                        title: const Text("Delete photo"),
                        leading: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                right: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                top: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            margin: const EdgeInsets.all(10),
            child: const Icon(Icons.edit),
          ),
        ),
      ],
    );
  }
}
