import 'package:flutter/material.dart';
import 'package:zenith_stores/components/bottom_nav_bar.dart';
import 'package:zenith_stores/constants.dart';
import 'package:zenith_stores/controllers/firebase_firestore_service.dart';
import 'package:zenith_stores/controllers/notification_service.dart';
import 'package:zenith_stores/screens/navi/account_screen.dart';
import 'package:zenith_stores/screens/navi/cart_screen.dart';
import 'package:zenith_stores/screens/navi/category.dart';
import 'package:zenith_stores/screens/navi/home_screen.dart';
import 'package:zenith_stores/screens/navi/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String id = 'MainScreen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver{
  int selectedIndex = 0;


  final notificationService = NotificationsService();
  @override
  void initState() {
    super.initState();
    notificationService.firebaseNotification(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestoreService.updateUserData('buyers',{
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


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  List<Widget> screens = [
    HomeScreen(),
    CustomerOrderScreen(),
    CartScreen(),
    SearchScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CustomBottomNavBar(

        selectedIndex: selectedIndex,
        selectedColor: kDarkGreenColor,
        unselectedColor: kGinColor,
        onTapped: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          Icon(Icons.home),
          Icon(Icons.shopping_bag),
          Icon(Icons.shopping_cart_outlined),
          Icon(Icons.search),
          Icon(Icons.person),
        ],
      ),
      body: screens[selectedIndex],
    );
  }
}
