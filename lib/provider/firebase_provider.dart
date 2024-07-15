import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zenith_stores/controllers/firebase_firestore_service.dart';
import 'package:zenith_stores/models/message.dart';
import 'package:zenith_stores/models/user.dart';

class FirebaseProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();

  List<UserModel> users = [];
  VendorModel? user;
  vUserModel? vendorchatuser;
  List<vUserModel> vuser= [];
  List<Message> messages = [];
  List<UserModel> search = [];

  List<UserModel> getAllUsers() {
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('lastActive', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((users) {
      this.users = users.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
      notifyListeners();
    });
    return users;
  }

  List<vUserModel> getmychatbyId(String? userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chat')
        .snapshots(includeMetadataChanges: true)
        .listen((users) {
      this.vuser = users.docs
          .map((doc) => vUserModel.fromJson(doc.data()))
          .toList();
      notifyListeners();
    });
    return vuser;
  }


  VendorModel? getreceiverById(String userId) {
    FirebaseFirestore.instance
        .collection('vendors')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.user = VendorModel.fromJson(user.data()!);
      notifyListeners();
    });
    return user;
  }

  List<Message> getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.messages = messages.docs
          .map((doc) => Message.fromJson(doc.data()))
          .toList();
      notifyListeners();

      scrollDown();
    });
    return messages;
  }

  void scrollDown() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(
              scrollController.position.maxScrollExtent);
        }
      });

  Future<void> searchUser(String name) async {
    search =
        await FirebaseFirestoreService.searchUser(name);
    notifyListeners();
  }



  ///------------------------------------------
/// this handles all the chat process for vendor chat
/// -----------------------------------------------
  VendorModel? getvendorchatById(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.vendorchatuser = vUserModel.fromJson(user.data()!);
      notifyListeners();
    });
    return user;
  }


}
