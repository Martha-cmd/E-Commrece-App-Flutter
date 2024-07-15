import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenith_stores/admin/views/auth/vendor_auth.dart';
import 'package:zenith_stores/components/authentication_button.dart';
import 'package:zenith_stores/components/custom_text_field.dart';
import 'package:zenith_stores/components/curve.dart';
import 'package:zenith_stores/components/utils/show_snackBar.dart';
import 'package:zenith_stores/constants.dart';
import 'package:zenith_stores/controllers/auth_controller.dart';
import 'package:zenith_stores/controllers/firebase_firestore_service.dart';
import 'package:zenith_stores/controllers/notification_service.dart';
import 'package:zenith_stores/screens/main_screen.dart';
import 'package:zenith_stores/screens/auth/signup_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  static final notifications = NotificationsService();

  bool rememberMe = false;
  late String email;
  late String password;
  bool _isLoading = false;

  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        try {


          await FirebaseFirestoreService.updateUserData('buyers',
            {'lastActive': DateTime.now()},
          );

          await notifications.requestPermission();
          await notifications.getToken();

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return MainScreen();
              }));
        } on FirebaseAuthException catch (e) {
          final snackBar = SnackBar(content: Text(e.message!));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

      } else {
        setState(() {
          _isLoading = false;
        });
        return showSnack(context, res);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      return showSnack(context, 'Please fields most not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.bottomRight,
        fit: StackFit.expand,
        children: [
          // First Child in the stack

          ClipPath(
            clipper: ImageClipper(),
            child: Image.asset(
              'images/logo.jpg',
              alignment: Alignment.topCenter,
              fit: BoxFit.contain,
            ),
          ),


          // Second Child in the stack
          Positioned(
            height: MediaQuery.of(context).size.height * 0.67,
            width: MediaQuery.of(context).size.width,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.67,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // First Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome Back',
                              style: GoogleFonts.poppins(
                                fontSize: 32.0,
                                fontWeight: FontWeight.w600,
                                color: kDarkGreenColor,
                              ),
                            ),
                            Text(
                              'Login to your customer account',
                              style: GoogleFonts.poppins(
                                color: kGreyColor,
                                fontSize: 15.0,
                              ),
                            )
                          ],
                        ),

                        // Second Column
                        Column(
                          children: [
                            CustomTextField(
                              hintText: 'Username',
                              icon: Icons.person,
                              bottom: 15,
                              keyboardType: TextInputType.name,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid username';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                email = value != '' ? value : '';
                              },
                            ),
                            CustomTextField(
                              hintText: 'Password',
                              icon: Icons.lock,
                              bottom: 15,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid password';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                password = value != '' ? value : '';
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        fillColor: MaterialStateProperty.all(
                                            kDarkGreenColor),
                                        value: rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            rememberMe = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Remember Me',
                                        style: TextStyle(
                                          color: kGreyColor,
                                          fontSize: 14.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Third Column
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            bottom: 20.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthenticationButton(
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 1,
                                      )
                                    : Text(
                                        'Log In',
                                        style:
                                            GoogleFonts.poppins(fontSize: 16.0),
                                      ),
                                onPressed: () {
                                  _loginUsers();
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Don\'t have an customer account ?',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(Size(0, 0)),
                                        padding:MaterialStateProperty.all(EdgeInsets.all(0)),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                kDarkGreenColor),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, SignupScreen.id);
                                      },
                                      child: const Text(
                                        'Sign up',
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Are you a Vendor? ',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(Size(0, 0)),
                                      padding:MaterialStateProperty.all(EdgeInsets.all(0)),
                                      foregroundColor:
                                      MaterialStateProperty.all(
                                          kDarkGreenColor),
                                    ),
                                    onPressed: () async {
                                         await _auth.signOut().whenComplete(() {
                                       Navigator.push(context,
                                           MaterialPageRoute(builder: (BuildContext context) {
                                             return VendorAuthScreen();
                                           }));
                                     },);},
                                    child: const Text(
                                      'Login or Sign up',
                                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
