
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith_stores/components/widgets/chat_messages.dart';
import 'package:zenith_stores/components/widgets/chat_text_field.dart';
import 'package:zenith_stores/provider/firebase_provider.dart';


class vChatScreen extends StatefulWidget {
  const vChatScreen({super.key, required this.userId});

  final String userId;

  @override
  State<vChatScreen> createState() => _vChatScreenState();
}

class _vChatScreenState extends State<vChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getvendorchatById(widget.userId)
      ..getMessages(widget.userId);

    _getDocument();
    super.initState();
  }
  Future<void> _getDocument() async {
    CollectionReference users = _firestore.collection('buyers');
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
            vendorChatTextField(receiverId: widget.userId)
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
        value.vendorchatuser != null
            ? Row(
          children: [
            CircleAvatar(
              backgroundImage:
              NetworkImage(value.vendorchatuser!.image),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text(
                  value.vendorchatuser!.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value.vendorchatuser!.isOnline
                      ? 'Online'
                      : 'Offline',
                  style: TextStyle(
                    color: value.vendorchatuser!.isOnline
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
