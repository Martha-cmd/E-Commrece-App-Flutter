import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zenith_stores/constants.dart';
import 'package:zenith_stores/controllers/firebase_firestore_service.dart';
import 'package:zenith_stores/controllers/media_service.dart';
import 'package:zenith_stores/controllers/notification_service.dart';
import 'custom_text_form_field.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField(
      {super.key, required this.receiverId});

  final String receiverId;

  @override
  State<ChatTextField> createState() =>
      _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final controller = TextEditingController();
  final notificationsService = NotificationsService();

  Uint8List? file;

  @override
  void initState() {
    notificationsService
        .getReceiverToken(widget.receiverId);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: controller,
              hintText: 'Add Message...',
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: kDarkGreenColor,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.send,
                  color: Colors.white),
              onPressed: () => _sendText(context),
            ),
          ),
          const SizedBox(width: 5),
          // CircleAvatar(
          //   backgroundColor: Colors.red,
          //   radius: 20,
          //   child: IconButton(
          //     icon: const Icon(Icons.camera_alt,
          //         color: Colors.white),
          //     onPressed: _sendImage,
          //   ),
          // ),
        ],
      );

  Future<void> _sendText(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      CollectionReference users = _firestore.collection('buyers');
      String documentId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot documentSnapshot = await users.doc(documentId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        print('Document data: $data');

        await FirebaseFirestoreService.addTextMessage(
          receiverId: widget.receiverId,
          content: controller.text,
            email: data['email'],
            id: data['buyerId'],
            image: data['profileImage'],
            isOnline: data['isOnline'],
            name: data['fullName'],
            phoneNumber: data['phoneNumber']

        );
        await notificationsService.sendNotification(
          body: controller.text,
          senderId: FirebaseAuth.instance.currentUser!.uid,
        );
        controller.clear();
        FocusScope.of(context).unfocus();
      } else {
        print('Document does not exist');
        FocusScope.of(context).unfocus();
      }

    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _sendImage() async {

    CollectionReference users = _firestore.collection('buyers');
    String documentId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot documentSnapshot = await users.doc(documentId).get();


    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String,
          dynamic>;
      print('Document data: $data');
      if (file != null) {
        await FirebaseFirestoreService.addImageMessage(
            receiverId: widget.receiverId,
            file: file!,
            email: data['email'],
            id: data['buyerId'],
            image: data['profileImage'],
            isOnline: data['isOnline'],
            name: data['fullname'],
            phoneNumber: data['phoneNumber']
        );
        await notificationsService.sendNotification(
          body: 'image........',
          senderId: FirebaseAuth.instance.currentUser!.uid,
        );
      }
    }else {
      print('Document does not exist');
      FocusScope.of(context).unfocus();
    }
  }
}


///-----------------------------------
///chat for vendor
///--------------------
class vendorChatTextField extends StatefulWidget {
  const vendorChatTextField(
      {super.key, required this.receiverId});

  final String receiverId;

  @override
  State<vendorChatTextField> createState() =>
      _vendorChatTextField();
}

class _vendorChatTextField extends State<vendorChatTextField> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final controller = TextEditingController();
  final notificationsService = NotificationsService();

  Uint8List? file;

  @override
  void initState() {
    notificationsService
        .getReceiverToken(widget.receiverId);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: CustomTextFormField(
          controller: controller,
          hintText: 'Add Message...',
        ),
      ),
      const SizedBox(width: 5),
      CircleAvatar(
        backgroundColor: kDarkGreenColor,
        radius: 20,
        child: IconButton(
          icon: const Icon(Icons.send,
              color: Colors.white),
          onPressed: () => _sendText(context),
        ),
      ),
      const SizedBox(width: 5),
      // CircleAvatar(
      //   backgroundColor: kDarkGreenColor,
      //   radius: 20,
      //   child: IconButton(
      //     icon: const Icon(Icons.camera_alt,
      //         color: Colors.white),
      //     onPressed: _sendImage,
      //   ),
      // ),
    ],
  );

  Future<void> _sendText(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      CollectionReference users = _firestore.collection('vendors');
      String documentId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot documentSnapshot = await users.doc(documentId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        print('Document data: $data');

        await FirebaseFirestoreService.addTextMessage(
            receiverId: widget.receiverId,
            content: controller.text,
            email: data['email'],
            id: data['vendorId'],
            image: data['storeImage'],
            isOnline: data['isOnline'],
            name: data['bussinessName'],
            phoneNumber: data['phoneNumber']

        );
        await notificationsService.sendNotification(
          body: controller.text,
          senderId: FirebaseAuth.instance.currentUser!.uid,
        );
        controller.clear();
        FocusScope.of(context).unfocus();
      } else {
        print('Document does not exist');
        FocusScope.of(context).unfocus();
      }

    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _sendImage() async {

    CollectionReference users = _firestore.collection('buyers');
    String documentId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot documentSnapshot = await users.doc(documentId).get();


    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String,
          dynamic>;
      print('Document data: $data');
      if (file != null) {
        await FirebaseFirestoreService.addImageMessage(
            receiverId: widget.receiverId,
            file: file!,
            email: data['email'],
            id: data['buyerId'],
            image: data['profileImage'],
            isOnline: data['isOnline'],
            name: data['fullname'],
            phoneNumber: data['phoneNumber']
        );
        await notificationsService.sendNotification(
          body: 'image........',
          senderId: FirebaseAuth.instance.currentUser!.uid,
        );
      }
    }else {
      print('Document does not exist');
      FocusScope.of(context).unfocus();
    }
  }
}