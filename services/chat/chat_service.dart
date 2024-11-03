import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class ChatService extends ChangeNotifier {
  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap(
      (snapshot) async {
        final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

        final usersSnapshot = await _firestore.collection('Users').get();

        return usersSnapshot.docs
            .where((doc) =>
                doc.data()['email'] != currentUser.email &&
                !blockedUserIds.contains(doc.id))
            .map((doc) => doc.data())
            .toList();
      },
    );
  }

  // get user Stream except blocked users
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap(
      (snapshot) async {
        final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

        final usersSnapshot = await _firestore
            .collection('Users')
            .doc(currentUser.uid)
            .collection('friends')
            .get();

        return usersSnapshot.docs
            .where((doc) =>
                doc.data()['email'] != currentUser.email &&
                !blockedUserIds.contains(doc.id))
            .map((doc) => doc.data())
            .toList();
      },
    );
  }

  // send message

  Future<void> sendMessage(
      String receiverId, String message, String replyMessage) async {
    final currentUserId = _auth.currentUser!.uid;
    final currentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail!,
      receiverId: receiverId,
      message: message,
      replyMessage: replyMessage,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();

    String chatRoomId = ids.join('_');

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // get message

  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // report User
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reporterId': currentUser!.uid,
      'messageID': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('Reports').add(report);
  }

  // Block User

  Future<void> blockuser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});
    notifyListeners();
  }
  // Add user to friend

  void addUser(String email, String firstName, String uid) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('friends')
        .doc(uid)
        .set(
      {
        'email': email,
        'firstName': firstName,
        'uid': uid,
      },
    );
  }

  // Unblock user

  Future<void> unblockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;

    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
  }

  void removeUser(uid) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('friends')
        .doc(uid)
        .delete();
  }

  // delete user account
  Future<void> deleteUser() async {
    final currentUser = _auth.currentUser;
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('Users').doc(currentUser!.uid).delete();
    await currentUser.delete();
  }

  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userID) {
    return _firestore
        .collection('Users')
        .doc(userID)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap(
      (snapshot) async {
        final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
        final userDocs = await Future.wait(
          blockedUserIds.map(
            (id) => _firestore.collection('Users').doc(id).get(),
          ),
        );
        return userDocs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      },
    );
  }
}
