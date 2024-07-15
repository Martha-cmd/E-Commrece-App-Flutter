
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith_stores/components/widgets/chat_messages.dart';
import 'package:zenith_stores/components/widgets/chat_text_field.dart';
import '../../provider/firebase_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getreceiverById(widget.userId)
      ..getMessages(widget.userId);

    _getDocument();
    super.initState();
  }
  Future<void> _getDocument() async {
    CollectionReference users = _firestore.collection('vendors');
    String documentId = widget.userId; // Replace with the ID of the document you want to retrieve

    try {
      DocumentSnapshot documentSnapshot = await users.doc(documentId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        print('Document data: $data');
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error getting document: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ChatMessages(receiverId: widget.userId),
            ChatTextField(receiverId: widget.userId)
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      title: Consumer<FirebaseProvider>(
        builder: (context, value, child) =>
            value.user != null
                ? Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(value.user!.storeImage),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          Text(
                            value.user!.bussinessName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            value.user!.isOnline
                                ? 'Online'
                                : 'Offline',
                            style: TextStyle(
                              color: value.user!.isOnline
                                  ? Colors.green
                                  : Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),
      ));
}
