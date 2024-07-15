import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zenith_stores/constants.dart';
import 'package:zenith_stores/provider/cart_provider.dart';
import 'package:zenith_stores/screens/main_screen.dart';
import 'package:zenith_stores/screens/otherscrens/edit_profile.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final formatCurrency =
    NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kDarkGreenColor,
              title: Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(child: Column(
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
                Text("Something went wrong",
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: kDarkGreenColor
                  ),textAlign: TextAlign.center,),
              ],
            )),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kDarkGreenColor,
              title: Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(child: Column(
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
                Text("Account does not exist as a buyer \ntry logging in as a vendor",
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: kDarkGreenColor
                  ),textAlign: TextAlign.center,),
              ],
            )),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          print(data['address']);
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kDarkGreenColor,
              title: Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: ListView.builder(
                shrinkWrap: true,
                itemCount: _cartProvider.getCartItem.length,
                itemBuilder: (context, index) {
                  final cartData =
                      _cartProvider.getCartItem.values.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: kGinColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: Row(children: [
                        Container(
                            height: 80.0,
                            width: 80.0,
                            margin: const EdgeInsets.only(right: 15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: NetworkImage(cartData.imageUrl[0]),
                              ),
                            )),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartData.productName,
                                style: GoogleFonts.poppins(
                                  color: kDarkGreenColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(formatCurrency.format(cartData.price),
                                style:  GoogleFonts.oswald(
                                  color: kDarkGreenColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              OutlinedButton(
                                onPressed: null,
                                child: Text(
                                  cartData.productSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  );
                }),
            bottomSheet: data['address'] == '' || data['address'] == null
                ? TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditPRofileScreen(
                          userData: data,
                        );
                      })).whenComplete(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: kDarkGreenColor,
                          borderRadius: BorderRadius.circular(10),
                        ),child: Center(child: Text('Enter Billing Address', style: GoogleFonts.poppins(color: Colors.white),))))
                : Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: InkWell(
                      onTap: () {
                        EasyLoading.show(status: 'Placing Order');

                        ///we want to be able to place order, but now know ,in future
                        ///
                        _cartProvider.getCartItem.forEach((key, item) {
                          final orderId = Uuid().v4();
                          _firestore.collection('orders').doc(orderId).set({
                            'orderId': orderId,
                            'vendorId': item.vendorId,
                            'email': data['email'],
                            'phone': data['phoneNumber'],
                            'address': data['address'],
                            'buyerId': data['buyerId'],
                            'fullName': data['fullName'],
                            'buyerPhoto': data['profileImage'],
                            'productName': item.productName,
                            'productPrice': item.price,
                            'productId': item.productId,
                            'productImage': item.imageUrl,
                            'quantity': item.quantity,
                            'productSize': item.productSize,
                            'scheduleDate': item.scheduleDate,
                            'orderDate': DateTime.now(),
                            'accepted': false,
                          }).whenComplete(() {
                            setState(() {
                              _cartProvider.getCartItem.clear();
                            });

                            EasyLoading.dismiss();

                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return MainScreen();
                            }));
                          });
                        });
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: kDarkGreenColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'PLACE ORDER',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 6,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: kDarkGreenColor,
          ),
        );
      },
    );
  }
}
