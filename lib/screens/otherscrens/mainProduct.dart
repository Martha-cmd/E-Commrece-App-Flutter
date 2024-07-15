import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenith_stores/constants.dart';
import 'package:zenith_stores/screens/productdetails/plant_details_screen.dart';
import 'package:intl/intl.dart';

class MainProductsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final formatCurrency =
    NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('approved', isEqualTo: true)
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
          builder: (context, constraints)  {
            return Container(
              // height: 265,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                  itemCount: snapshot.data!.size,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 1,
                      childAspectRatio: (constraints.maxWidth/1.8) / (constraints.maxHeight /1.37)),
                  itemBuilder: (context, index) {
                    final productData = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return ProductDetailScreen(
                                productData: productData,
                              );
                            }));
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height:  constraints.maxHeight / 3.1,
                                  margin: EdgeInsets.all(5),
                                  // width: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        productData['imageUrl'][0],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin:EdgeInsets.only(bottom: 5.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: kDarkredColor, // Border color
                                      width: 1.0, // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(6.0), // Border radius
                                  ),
                                  child: Center(
                                    child: Text(productData['category'],style: TextStyle(
                                        color: kDarkredColor,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                ),
                              ],
                            ),
                            Text(productData['productName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 15
                              ),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formatCurrency.format(double.parse("${productData['productPrice']}")),style: GoogleFonts.oswald(
                                    fontWeight: FontWeight.w500,
                                    fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 16,
                                    color: kDarkGreenColor
                                ),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.star,size:15,color: Colors.orange,),
                                    Text('4.9',style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  ],
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),

                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
        );
      },
    );
  }
}


class PlantCard extends StatelessWidget {
  const PlantCard({
    required this.plantType,
    required this.plantName,
    required this.plantPrice,
    required this.image,
    required this.onTap,
    required this.onTapp,
    Key? key,
  }) : super(key: key);

  final String plantType;
  final String plantName;
  final double plantPrice;
  final Image image;
  final Function() onTap;
  final Function() onTapp;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
          child: Row(
            children: [
              Container(
                // height: 250,
                width: 140,
                color:Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        image,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: kDarkGreenColor,
                              padding: EdgeInsets.all(0),
                              margin: EdgeInsets.all(0),
                              child: Center(
                                child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    color: Colors.white,
                                    splashRadius: 18.0,
                                    icon: const Icon(
                                      Icons.shopping_cart_outlined,size: 15,
                                    ),
                                    onPressed: onTapp
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: kDarkredColor, // Border color
                                    width: 1.0, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(6.0), // Border radius
                                ),
                                child: Center(
                                  child: Text(plantType,style: TextStyle(
                                      color: kDarkredColor,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                              ),
                            ],
                          ),
                          Text(plantName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('\N$plantPrice',style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: kDarkGreenColor
                              ),),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.star,size:15,color: Colors.orange,),
                                  Text('4.9',style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}