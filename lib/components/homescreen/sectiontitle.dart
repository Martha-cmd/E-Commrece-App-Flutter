import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zenith_stores/constants.dart';
import 'package:zenith_stores/screens/navi/home_screen.dart';
import 'package:zenith_stores/screens/otherscrens/all_products_screen.dart';

class sectionTitle extends StatefulWidget {
  final String title;
  const sectionTitle({required this.title, super.key});

  @override
  State<sectionTitle> createState() => _sectionTitleState();
}

class _sectionTitleState extends State<sectionTitle> {
  String? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _catgoryStream =
    FirebaseFirestore.instance.collection('categories').snapshots();
    return  Padding(
      padding:
      const EdgeInsets.only(top: 10.0, left: 10.0,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: kDarkGreenColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _catgoryStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Loading categories"),
                );
              }

              return Container(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final categoryData = snapshot.data!.docs[index];
                    return PCard(
                      cartName: categoryData['categoryName'],
                      image: Image.network(
                        categoryData['image'],
                        alignment: Alignment.center, width: 9,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCategory =
                          categoryData['categoryName'];
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return AllProductScreen(
                                categoryData: categoryData ,
                              );
                            }));
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10.0);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
