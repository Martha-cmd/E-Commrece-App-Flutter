import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith_stores/components/widgets/user_item.dart';
import 'package:zenith_stores/controllers/notification_service.dart';
import 'package:zenith_stores/provider/firebase_provider.dart';


class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with WidgetsBindingObserver {
  final notificationService = NotificationsService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<FirebaseProvider>(context, listen: false)
        .getmychatbyId(FirebaseAuth.instance.currentUser?.uid);

    notificationService.firebaseNotification(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) => Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: SafeArea(
            child: Consumer<FirebaseProvider>(
                builder: (context, value, child) {
              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                itemCount: value.vuser.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => value
                            .vuser[index].Id !=
                        FirebaseAuth.instance.currentUser?.uid
                    ? UserItem(user: value.vuser[index])
                    : const SizedBox(),
              );
            }),
          ),
      ),
      );
}
