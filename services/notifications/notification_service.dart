// import 'package:chatapp/components/user_tile.dart';
// import 'package:chatapp/pages/chat_page.dart';
// import 'package:chatapp/services/auth/auth_service.dart';
// import 'package:chatapp/services/chat/chat_service.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final AuthService _authService = AuthService();
//   final ChatService _chatService = ChatService();

//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();

//     final token = await _firebaseMessaging.getToken();

//     print('Token ${token}');
//   }

//   Future<void> handleMessage(RemoteMessage? message) async {
//     if (message == null) return;
//   }

//   Future<void> initPushNotification() async {
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     // _firebaseMessaging.
//   }

//   // Widget _buildUserList(context) {
//   //   return StreamBuilder(
//   //     stream: _chatService.getUsersStreamExcludingBlocked(),
//   //     builder: (context, snapshot) {
//   //       if (snapshot.hasError) {
//   //         return const Text("Error");
//   //       }
//   //       if (snapshot.connectionState == ConnectionState.waiting) {
//   //         return const Center(child: CircularProgressIndicator());
//   //       }
//   //       return ListView(
//   //         children: snapshot.data!
//   //             .map<Widget>((userData) => _buildUserListItem(userData, context))
//   //             .toList(),
//   //       );
//   //     },
//   //   );
//   // }

//   // Widget _buildUserListItem(
//   //     Map<String, dynamic> userdata, BuildContext context) {
//   //   if (userdata['email'] != _authService.getCurrentUser()!.email) {
//   //     return UserTile(
//   //       text: userdata['firstName'],
//   //       onTap: () {
//   //         Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) => ChatPage(
//   //               receiverId: userdata['uid'],
//   //               receiverName: userdata['firstName'],
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     );
//   //   } else {
//   //     return Container();
//   //   }
//   // }
// }
