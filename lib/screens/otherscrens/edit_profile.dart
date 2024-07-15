import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenith_stores/constants.dart';

class EditPRofileScreen extends StatefulWidget {
  final dynamic userData;

  EditPRofileScreen({super.key, required this.userData});

  @override
  State<EditPRofileScreen> createState() => _EditPRofileScreenState();
}

class _EditPRofileScreenState extends State<EditPRofileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  String? address;
  @override
  void initState() {
    setState(() {
      _fullNameController.text = widget.userData['fullName'];
      _emailController.text = widget.userData['email'];
      _phoneController.text = widget.userData['phoneNumber'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            color: kDarkGreenColor,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: kDarkGreenColor ,
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(CupertinoIcons.photo),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(18.0),
                      filled: true,
                      fillColor: kGinColor,
                      prefixIcon: Icon(
                        Icons.person,
                        size: 24.0,
                        color: kDarkGreenColor,
                      ),
                      labelText: 'Enter Full Name',
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

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(18.0),
                      filled: true,
                      fillColor: kGinColor,
                      prefixIcon: Icon(
                        Icons.mail,
                        size: 24.0,
                        color: kDarkGreenColor,
                      ),
                      labelText: 'Enter Email',
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(18.0),
                      filled: true,
                      fillColor: kGinColor,
                      prefixIcon: Icon(
                        Icons.phone,
                        size: 24.0,
                        color: kDarkGreenColor,
                      ),
                      labelText: 'Enter Phone Number',
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      address = value ?? '';
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(18.0),
                      filled: true,
                      fillColor: kGinColor,
                      prefixIcon: Icon(
                        Icons.location_on_rounded,
                        size: 24.0,
                        color: kDarkGreenColor,
                      ),
                      labelText: 'Enter Address',
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(13.0),
        child: InkWell(
          onTap: () async {
            EasyLoading.show(status: 'UPDATING');
            await _firestore
                .collection('buyers')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'fullName': _fullNameController.text,
              'email': _emailController.text,
              'phoneNumber': _phoneController.text,
              'address': address,
            }).whenComplete(() {
              EasyLoading.dismiss();

              Navigator.pop(context);
            });
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: kDarkGreenColor ,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Text(
                  'Update',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18),
                )),
          ),
        ),
      ),
    );
  }
}
