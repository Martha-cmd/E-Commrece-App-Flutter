import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zenith_stores/constants.dart';

class CustomerOrderScreen extends StatelessWidget {
  static const String id = 'CustomerOrderScreen';
  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outPutDateFormate.format(date);

    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency =
    NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kDarkGreenColor ,
          elevation: 0,
          title: Center(
            child: Text(
              'My Orders',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 5,
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _ordersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LinearProgressIndicator(
                  color: kDarkGreenColor ,
                ),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 14,
                              child: document['accepted'] == true
                                  ? Icon(Icons.delivery_dining, color: kDarkGreenColor,)
                                  : Icon(Icons.access_time, color: kDarkGreenColor,)),
                          title: document['accepted'] == true
                              ? Text(
                            'Accepted',
                            style: TextStyle(color: kDarkGreenColor ),
                          )
                              : Text(
                            'Not Accepted',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          trailing: Text(
                            formatCurrency.format(

                                    document['productPrice'] *document['quantity']),
                            style: GoogleFonts.oswald(fontSize: 17, color:kDarkGreenColor),
                          ),
                          subtitle: Text(
                            formatedDate(
                              document['orderDate'].toDate(),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:kDarkGreenColor,
                            ),
                          ),
                        ),
                        ExpansionTile(
                          title: Text(
                            'Order Details',
                            style: TextStyle(
                              color: kDarkGreenColor ,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text('View Order Details'),
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                child: Image.network(
                                  document['productImage'][0],
                                ),
                              ),
                              title: Text(document['productName']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        ('Quantity'),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        document['quantity'].toString(),
                                      ),
                                    ],
                                  ),
                                  document['accepted'] == true
                                      ? Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Schedule Delivery Date'),
                                      Text(formatedDate(
                                          document['scheduleDate'].toDate()))
                                    ],
                                  )
                                      : Text(''),
                                  ListTile(
                                    title: Text(
                                      'Buyer Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(document['fullName']),
                                        Text(document['email']),
                                        Text(document['address']),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ));
  }
}
