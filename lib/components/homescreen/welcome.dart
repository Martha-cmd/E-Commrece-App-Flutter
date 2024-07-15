import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenith_stores/constants.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    if (_auth.currentUser == null) {
      return Container(); // Return an empty container if the user is not logged in
    }

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hello! ',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: kDarkGreenColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(' ',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: kDarkGreenColor,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                'Let\'s find your preferred Sports outfit!',
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  color: kDarkGreenColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hello! ',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: kDarkGreenColor,
                      fontSize:15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(' ',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: kDarkGreenColor,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                'Let\'s find your preferred Sports outfit!',
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  color: kDarkGreenColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hello! ',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: kDarkGreenColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    data['fullName'],
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: kDarkGreenColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                'Let\'s find your preferred Sports outfit!',
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  color: kDarkGreenColor,
                  fontSize:12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }
        // Return a fallback widget if none of the conditions are met.
        return Center(
          child: LinearProgressIndicator(
            color: kDarkGreenColor ,
          ),
        ); // You can change this to any other widget.
      },
    );
  }

}