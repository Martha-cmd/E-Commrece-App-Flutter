import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zenith_stores/components/authentication_button.dart';
import 'package:zenith_stores/components/homescreen/banner.dart';
import 'package:zenith_stores/components/homescreen/sectiontitle.dart';
import 'package:zenith_stores/components/homescreen/welcome.dart';
import 'package:zenith_stores/constants.dart';
import 'package:zenith_stores/provider/cart_provider.dart';
import 'package:zenith_stores/screens/auth/login_screen.dart';
import 'package:zenith_stores/screens/otherscrens/mainProduct.dart';
import 'package:zenith_stores/screens/otherscrens/recentproduct.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('approved', isEqualTo: true)
      .snapshots();
  int selected = 0;


  void showTopSnackBar(
    String message, {
    bool isSuccess = true,
    Color? color,
    Duration? duration,
  }) {
    final backgroundColor =
        color ?? (isSuccess ? Colors.green[600] : Colors.red[600]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration ?? const Duration(milliseconds: 500),
        backgroundColor: Colors.transparent,
        content: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 100,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildCartWidget() {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    if (_cartProvider.getCartItem.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.red,
        radius: 8.0,
      );
    } else {
      // Return an empty container or some other placeholder when the condition is not met.
      return Container();
    }
  }
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
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
                        Icons.support_agent_rounded,
                        // Replace with your desired icon
                        size: 80.0,
                        weight: 2.0,
                        color: kDarkGreenColor,
                      ),
                    ),
                  ),
                  Text(
                    "Something went wrong",
                    style: GoogleFonts.poppins(
                        fontSize: 20, color: kDarkGreenColor),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthenticationButton(
                          child:Text(
                            'Log In',
                            style:
                            GoogleFonts.poppins(fontSize: 16.0),
                          ),
                          onPressed: () async {
                            await _auth.signOut().whenComplete(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  }));
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            );
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Scaffold(
              body: Center(
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
                        Icons.support_agent_rounded,
                        // Replace with your desired icon
                        size: 80.0,
                        weight: 2.0,
                        color: kDarkGreenColor,
                      ),
                    ),
                  ),
                  Text(
                    "Account does not exist as a buyer \ntry logging in as a vendor",
                    style: GoogleFonts.poppins(
                        fontSize: 20, color: kDarkGreenColor),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthenticationButton(
                          child:Text(
                            'Log In',
                            style:
                            GoogleFonts.poppins(fontSize: 16.0),
                          ),
                          onPressed: () async {
                            await _auth.signOut().whenComplete(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  }));
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  leadingWidth: 0,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: kDarkGreenColor,
                          radius: 22.0,
                          backgroundImage: const AssetImage('images/logo.jpg'),
                        ),
                        onTap: () {},
                      ),
                      WelcomeText(),
                      CircleAvatar(
                        backgroundColor: kDarkGreenColor,
                        radius: 22.0,
                        child: Stack(
                          children: [
                            IconButton(
                              color: Colors.white,
                              splashRadius: 28.0,
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                              ),
                              onPressed: () {
                              },
                            ),
                            buildCartWidget()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                body: Container(
                  child: Column(
                    children: [
                      Expanded(
                        // flex: 9,
                        child: ListView(
                          children: [
                            // WelcomeText(),
                            BannerWidget(),
                            sectionTitle(title: 'Categories'),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: 20.0, horizontal: 10.0),
                            //   child: Text(
                            //     'Recently Viewed',
                            //     style: TextStyle(
                            //       color: kDarkGreenColor,
                            //       fontSize: 16.0,
                            //       fontWeight: FontWeight.w600,
                            //     ),
                            //   ),
                            // ),
                            // RecentProductsWidget(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Text(
                                'View Products',
                                style: TextStyle(
                                  color: kDarkGreenColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                                height: 360.0,
                                alignment: Alignment.bottomCenter,
                                child: MainProductsWidget()
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Center(
            child: LinearProgressIndicator(
              color: kDarkGreenColor ,
            ),
          );
        });
  }
}

class RecentlyViewedCard extends StatelessWidget {
  const RecentlyViewedCard({
    required this.plantName,
    required this.plantInfo,
    required this.plantPrice,
    required this.image,
    Key? key,
  }) : super(key: key);

  final String plantName;
  final String plantInfo;
  final String plantPrice;
  final ImageProvider<Object> image;

  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return Container(
      width: MediaQuery.of(context).size.width/1.6,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width:MediaQuery.of(context).size.width/4.5,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image,
                fit: BoxFit.fill
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatCurrency.format(double.parse('$plantPrice')),
                  style: GoogleFonts.oswald(
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width/23.0,
                      color: kDarkGreenColor),
                ),
                Text(
                  plantName,
                  style: GoogleFonts.poppins(
                    color: kDarkGreenColor,
                    fontSize: MediaQuery.of(context).size.width/22.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                FadeTransition(
                  opacity: AlwaysStoppedAnimation(2),
                  child: Text(
                    plantInfo.length <= 15
                        ? plantInfo
                        : '${plantInfo.substring(0, 15)}...',
                    style: GoogleFonts.poppins(
                      color: kGreyColor,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
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
                color: Colors.white,
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
                                      Icons.shopping_cart_outlined,
                                      size: 15,
                                    ),
                                    onPressed: onTapp),
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
                                  borderRadius: BorderRadius.circular(
                                      6.0), // Border radius
                                ),
                                child: Center(
                                  child: Text(
                                    plantType,
                                    style: TextStyle(
                                        color: kDarkredColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            plantName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\N$plantPrice',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: kDarkGreenColor),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 15,
                                    color: Colors.orange,
                                  ),
                                  Text(
                                    '4.9',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
        ));
  }
}

class PlantsCard extends StatelessWidget {
  const PlantsCard({
    required this.plantType,
    required this.plantName,
    required this.plantPrice,
    required this.image,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String plantType;
  final String plantName;
  final double plantPrice;
  final Image image;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // height: 250,
                width: 170,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    image,
                    const SizedBox(
                      height: 5,
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
                                  borderRadius: BorderRadius.circular(
                                      6.0), // Border radius
                                ),
                                child: Center(
                                  child: Text(
                                    plantType,
                                    style: TextStyle(
                                        color: kDarkredColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            plantName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\N$plantPrice',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: kDarkGreenColor),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  Text(
                                    '4.9 | 2336',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    Key? key,
    required this.selected,
    required this.categories,
    required this.onTap,
  }) : super(key: key);

  final int selected;
  final List<String> categories;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < categories.length; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              padding: EdgeInsets.symmetric(
                vertical: selected == i ? 8.0 : 0.0,
                horizontal: selected == i ? 12.0 : 0.0,
              ),
              decoration: BoxDecoration(
                color: selected == i ? kGinColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: GestureDetector(
                onTap: () {
                  onTap(i);
                },
                child: Align(
                  child: Text(
                    categories[i],
                    style: TextStyle(
                      color: selected == i ? kDarkGreenColor : kGreyColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PCard extends StatelessWidget {
  const PCard({
    required this.cartName,
    required this.image,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String cartName;
  final Image image;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: kGinColor, borderRadius: BorderRadius.circular(10)),
              child: image,
            ),
            const SizedBox(
              height:5,
            ),
            Text(
              cartName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
