import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenith_stores/models/message.dart';
import 'package:zenith_stores/models/user.dart';
import 'firebase_storage_service.dart';

class FirebaseFirestoreService {
  static final firestore = FirebaseFirestore.instance;
  static Future<void> addTextMessage({
    required String content,
    required String receiverId,
    required String email,
    required String id,
    required String image,
    required bool isOnline,
    required String name,
    required String phoneNumber,
  }) async {
    final message = Message(
      content: content,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );

    final updatefield = Updatefield(
      email: email,
      id: id,
      image: image,
      isOnline: isOnline,
      lastActive: DateTime.now(),
      name: name,
      phoneNumber: phoneNumber,
    );
    await _addMessageToChat(receiverId, message, updatefield);
  }

  static Future<void> addImageMessage({
    required String receiverId,
    required Uint8List file,
    required String email,
    required String id,
    required String image,
    required bool isOnline,
    required String name,
    required String phoneNumber,
  }) async {
    final image = await FirebaseStorageService.uploadImage(
        file, 'image/chat/${DateTime.now()}');

    final message = Message(
      content: image,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.image,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );

    final updatefield = Updatefield(
      email: email,
      id: id,
      image: image,
      isOnline: isOnline,
      lastActive: DateTime.now(),
      name: name,
      phoneNumber: phoneNumber,
    );
    await _addMessageToChat(receiverId, message, updatefield);
  }

  static Future<void> _addMessageToChat(
    String receiverId,
    Message message,
      Updatefield updatefield
  ) async {

    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(message.toJson());


    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid).set(updatefield.toJson(), SetOptions(merge: true));
  }

  static Future<void> updateUserData(String whois,
          Map<String, dynamic> data) async =>
      await firestore
          .collection(whois)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);

  static Future<List<UserModel>> searchUser(
      String name) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("name", isGreaterThanOrEqualTo: name)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();
  }
}
