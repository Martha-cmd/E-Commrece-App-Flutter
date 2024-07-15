import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenith_stores/constants.dart';
import 'package:zenith_stores/screens/auth/login_screen.dart';

class VendorLogoutScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('vendors');

    return _auth.currentUser == null
        ? Column(
      children: [
        Center(
          child: TextButton(
            onPressed: () async {
              _auth.signOut();
            },
            child: Text(
              'Signout',
            ),
          ),
        ),
      ],
    ) : FutureBuilder<DocumentSnapshot>(future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(), builder: (BuildContext context,
        AsyncSnapshot<DocumentSnapshot> snapshot){
      if(snapshot.hasError){
        return const Text("Something went wrong");
      }
      if(snapshot.hasData && !snapshot.data!.exists){
          return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    width: 100.0, // Adjust the width as needed
                    height: 100.0, // Adjust the height as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: kDarkGreenColor,
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.support_agent_rounded, // Replace with your desired icon
                        size: 80.0,
                        weight: 2.0,
                        color: kDarkGreenColor,
                      ),
                    ),
                  ),
                  Text("Account does not exist as a Vendor \ntry logging in as a vendor",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: kDarkGreenColor
                    ),textAlign: TextAlign.center,),
                ],
              )
          );
      }
      if (snapshot.connectionState == ConnectionState.done){
        Map<String, dynamic> data =
        snapshot.data!.data() as Map<String, dynamic>;
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: kDarkGreenColor,
                    backgroundImage: NetworkImage(data['storeImage']),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    data['bussinessName'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['email'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //       return EditPRofileScreen(
                    //         userData: data,
                    //       );
                    //     }));
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 200,
                    decoration: BoxDecoration(
                      color: kDarkGreenColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                          'Edit Profile',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            leading: Icon(Icons.email, color: kDarkGreenColor,),
                            title: const Text("E-Mail",
                                style: TextStyle(fontSize: 16, color: Colors.black)),
                            subtitle: Text(data['email'],
                                style:
                                const TextStyle(fontSize: 15, color: Colors.black54)),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(Icons.phone, color: kDarkGreenColor,),
                            title: const Text("Phone",
                                style: TextStyle(fontSize: 16, color: Colors.black)),
                            subtitle: Text(data['phoneNumber'],
                                style:
                                const TextStyle(fontSize: 15, color: Colors.black54)),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(Icons.location_history_rounded, color: kDarkGreenColor,),
                            title: const Text("City",
                                style: TextStyle(fontSize: 16, color: Colors.black)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(data['cityValue'],
                                  style:
                                  const TextStyle(fontSize: 15, color: Colors.black54)),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(Icons.location_history_rounded, color: kDarkGreenColor,),
                            title: const Text("State",
                                style: TextStyle(fontSize: 16, color: Colors.black)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(data['stateValue'],
                                  style:
                                  const TextStyle(fontSize: 15, color: Colors.black54)),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(Icons.location_history_rounded, color: kDarkGreenColor,),
                            title: const Text("Country",
                                style: TextStyle(fontSize: 16, color: Colors.black)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(data['countryValue'],
                                  style:
                                  const TextStyle(fontSize: 15, color: Colors.black54)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await _auth.signOut().whenComplete(() {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                    return const LoginScreen();
                                  }));
                            });
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 200,
                            decoration: BoxDecoration(
                              color: kDarkGreenColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Icon(Icons.logout, color: Colors.white),
                                    ),
                                    Text(
                                      'Logout',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Center(child: LinearProgressIndicator(
        color: kDarkGreenColor ,
      ),);
    });
  }
}
