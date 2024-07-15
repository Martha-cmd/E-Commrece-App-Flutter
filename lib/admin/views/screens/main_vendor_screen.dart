import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zenith_stores/admin/views/chat/chats_screen.dart';
import 'package:zenith_stores/admin/views/screens/earnings_screen.dart';
import 'package:zenith_stores/admin/views/screens/edit_product_screen.dart';
import 'package:zenith_stores/admin/views/screens/upload_screen.dart';
import 'package:zenith_stores/admin/views/screens/vendor_logout_Screen.dart';
import 'package:zenith_stores/admin/views/screens/vendor_order_screen.dart';
import 'package:zenith_stores/constants.dart';
import 'package:zenith_stores/controllers/firebase_firestore_service.dart';
import 'package:zenith_stores/controllers/notification_service.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> with WidgetsBindingObserver{

  static final notifications = NotificationsService();
  final notificationService = NotificationsService();
  @override
  void initState() {
    super.initState();
    notificationService.firebaseNotification(context);
    getnotification();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestoreService.updateUserData('vendors',{
          'lastActive': DateTime.now(),
          'isOnline': true,
        });
        break;

      case AppLifecycleState.inactive:

      case AppLifecycleState.paused:

      case AppLifecycleState.detached:
        FirebaseFirestoreService.updateUserData(
            'buyers',
            {'isOnline': false});
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  getnotification() async {
    try {


      await FirebaseFirestoreService.updateUserData('vendors',
        {'lastActive': DateTime.now()},
      );

      await notifications.requestPermission();
      await notifications.getToken();

    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  int _pageIndex = 0;

  List<Widget> _pages = [
    EarningsScreen(),
    UploadScreen(),
    EditProductScreen(),
    VendorOrderScreen(),
    ChatsScreen(),
    VendorLogoutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: ((value) {
            setState(() {
              _pageIndex = value;
            });
          }),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: kGinColor,
          selectedItemColor: kDarkGreenColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.money_dollar),
              label: 'EARNINGS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.upload),
              label: 'UPLOAD',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: 'EDIT',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.shopping_cart),
              label: 'ORDERS',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_2_fill),
              label: 'chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'LOGOUT',
            ),
          ]),
      body: _pages[_pageIndex],
    );
  }
}
