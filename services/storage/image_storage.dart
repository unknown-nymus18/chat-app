import 'dart:io';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageStorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  // Upload an image from gallery
  Future<String> uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? image = File(pickedFile.path);
      Reference ref = _storage.ref().child(
            'images/${_authService.getCurrentUser()!.uid}',
          );
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    return '';
  }

  // Retrieve an image from the Storage
  Future<String> retrieveImage() async {
    try {
      Reference ref = _storage.ref().child(
            'images/${_authService.getCurrentUser()!.uid}',
          );
      String dowloadUrl = await ref.getDownloadURL();
      return dowloadUrl;
    } catch (e) {
      return '';
    }
  }

  // get  User's image from storage

  Future<String> retrieveImageUser(String userId) async {
    try {
      Reference ref = _storage.ref().child(
            'images/$userId',
          );
      String dowloadUrl = await ref.getDownloadURL();
      return dowloadUrl;
    } catch (e) {
      return '';
    }
  }

  // Delete picture

  Future<String> deletePicture() async {
    try {
      Reference ref = _storage.ref().child(
            'images/${_authService.getCurrentUser()!.uid}',
          );
      await ref.delete();
      return '';
    } catch (e) {
      return '';
    }
  }

  // Upload a picture from camera
  Future<String> uploadCameraPicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File? image = File(pickedFile.path);
      Reference ref = _storage.ref().child(
            'images/${_authService.getCurrentUser()!.uid}',
          );
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    return '';
  }
}
