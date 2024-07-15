import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenith_stores/constants.dart';
import 'package:zenith_stores/screens/productdetails/plant_details_screen.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = "";
  @override
  Widget build(BuildContext context) {
    final formatCurrency =
    NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('approved', isEqualTo: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        elevation: 1,
        backgroundColor: kDarkGreenColor ,
        title: Text(
          'All Product',
          style: TextStyle(
            letterSpacing: 6,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0), // Adjust the height as needed
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Search For Products',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(Icons.search, color: kDarkGreenColor,)
                    )),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body:StreamBuilder<QuerySnapshot>(
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
          final filteredProducts = snapshot.data!.docs.where((productData) {
            final productName = productData['productName'].toString().toLowerCase();
            return productName.contains(_searchQuery.toLowerCase());
          }).toList();
          return LayoutBuilder(
              builder: (context, constraints) {
              return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                      itemCount: filteredProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 8,
                          childAspectRatio: (constraints.maxWidth/1.8) / (constraints.maxHeight / 1.7)),
                      itemBuilder: (context, index) {
                        final productData = filteredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return ProductDetailScreen(
                                    productData: productData,
                                  );
                                }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height:  constraints.maxHeight / 3.6,
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
                          ),
                        );
                      }),
                );
            }
          );
        },
      ),
    );
  }
}
