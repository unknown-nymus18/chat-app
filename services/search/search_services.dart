import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

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
}
