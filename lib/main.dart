import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenith_stores/firebase_options.dart';
import 'package:zenith_stores/provider/registry.dart';
import 'package:zenith_stores/screens/navi/cart_screen.dart';
import 'package:zenith_stores/screens/navi/category.dart';
import 'package:zenith_stores/screens/navi/home_screen.dart';
import 'package:zenith_stores/screens/auth/login_screen.dart';
import 'package:zenith_stores/screens/main_screen.dart';
import 'package:zenith_stores/screens/auth/signup_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await FirebaseMessaging.instance.getInitialMessage();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);

  runApp(MultiProvider(providers: providers,child: MyApp()));
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),

      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) =>  SignupScreen(),
        MainScreen.id: (context) => MainScreen(),
        HomeScreen.id: (context) =>  HomeScreen(),
        CustomerOrderScreen.id: (context) =>  CustomerOrderScreen(),
        CartScreen.id: (context) =>  CartScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
