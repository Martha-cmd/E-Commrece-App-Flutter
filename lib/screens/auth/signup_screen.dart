import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zenith_stores/components/authentication_button.dart';
import 'package:zenith_stores/components/custom_text_field.dart';
import 'package:zenith_stores/components/utils/show_snackBar.dart';
import 'package:zenith_stores/constants.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:zenith_stores/controllers/auth_controller.dart';


class SignupScreen extends StatefulWidget {

  static String id = 'SignupScreen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  late String email;

  late String fullName;

  late String phoneNumber;

  late String password;
  late String confirmpassword;

   bool _isLoading = false;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _isLoading= false;
  }

  selectGalleryImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  selectCameraImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.camera);

    setState(() {
      _image = im;
    });
  }


  _signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      await _authController
          .signUpUSers(email, fullName, phoneNumber, password, _image)
          .whenComplete(() {
        setState(() {
          _formKey.currentState!.reset();
          _isLoading = false;
        });
      });

      return showSnack(
          context, 'Congratulations Account has been Created For You');
    } else {
      setState(() {
        _isLoading = false;
      });
      return showSnack(context, 'Please Fields must not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        'Register',
                        style: GoogleFonts.poppins(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w600,
                          color: kDarkGreenColor,
                        ),
                      ),
                      Text(
                        'Create a new account',
                        style: GoogleFonts.poppins(
                          color: kGreyColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key:_formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            _image != null
                                ? CircleAvatar(
                              radius: 54,
                              backgroundColor: kDarkGreenColor,
                              backgroundImage: MemoryImage(_image!),
                            )
                                : CircleAvatar(
                              radius: 54,
                              backgroundColor: kDarkGreenColor,
                              backgroundImage: NetworkImage(
                                  'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                            ),
                            Positioned(
                              right: 0,
                              top: 5,
                              child: IconButton(
                                onPressed: () {
                                  selectGalleryImage();
                                },
                                icon: Icon(
                                  Icons.photo,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomTextField(
                        hintText: 'Full Name',
                        bottom: 10,
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          fullName = value;
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Fullname';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hintText: 'Email',
                        icon: Icons.mail,
                        bottom: 10,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          email = value;
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email address';
                          }
                          bool isValid = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value);
                          if (!isValid) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },

                      ),
                      CustomTextField(
                        hintText: 'Phone Number',
                        bottom: 10,
                        icon: Icons.lock,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          phoneNumber = value;
                        },
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }},


                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }},
                          cursorColor: kDarkGreenColor,
                          obscureText: true,
                          keyboardType: TextInputType.name,
                          style: GoogleFonts.poppins(
                            color: kDarkGreenColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(18.0),
                            filled: true,
                            fillColor: kGinColor,
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 24.0,
                              color: kDarkGreenColor,
                            ),
                            hintText: 'Enter a password',
                            hintStyle: GoogleFonts.poppins(
                              color: kDarkGreenColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: kGinColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: kDarkGreenColor),
                            ),
                          ),
                          onChanged:(value) {
                      password = value;
                      },
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: FlutterPwValidator(
                          controller: passwordController,
                          minLength: 8,
                          uppercaseCharCount: 1,
                          lowercaseCharCount: 1,
                          numericCharCount: 1,
                          specialCharCount: 1,
                          width: 400,
                          height: 120,
                          onSuccess: (){},
                          onFail: (){},
                        ),)
                      ,
                      CustomTextField(
                        hintText: 'Confirm Password',
                        icon: Icons.lock,
                        bottom: 10,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {},
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null; // Return null if the input is valid
                        },
                      )
                      ,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'By signing you agree to our ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: kDarkGreenColor,
                            ),
                          ),
                          Text(
                            ' Terms of use',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: kGreyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'and ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: kDarkGreenColor,
                            ),
                          ),
                          Text(
                            ' privacy notice',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: kGreyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              child: AuthenticationButton(
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : Text(
                                  'Sign Up',
                                  style:
                                  GoogleFonts.poppins(fontSize: 16.0),
                                ),
                                onPressed: () {
                                  _signUpUser();
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 30.0,
            left: 20.0,
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: 20.0,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: kDarkGreenColor,
                  size: 24.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
