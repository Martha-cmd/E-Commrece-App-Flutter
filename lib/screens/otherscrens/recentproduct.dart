import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zenith_stores/constants.dart';
import 'package:zenith_stores/screens/navi/home_screen.dart';


class RecentProductsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('approved', isEqualTo: true)
        .orderBy('scheduleDate', descending: true) // Assuming you have a 'timestamp' field
        .limit(15) // Limit the query to the latest 15 records
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
        return LayoutBuilder(
            builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: constraints.maxWidth/4,
                width: constraints.maxWidth/4,
                child: ListView.separated(
                  itemCount: snapshot.data!.size,
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final productData = snapshot.data!.docs[index];
                    return RecentlyViewedCard(
                      plantName: productData['productName'],
                      plantInfo: productData['description'],
                      plantPrice: "${productData['productPrice']}",
                      image: NetworkImage(productData['imageUrl'][0]),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: constraints.maxWidth/20);
                  },
                ),
              ),
            );
          }
        );
      },
    );
  }
}
