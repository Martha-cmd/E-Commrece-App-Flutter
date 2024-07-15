import 'dart:async';
import 'dart:io';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:zenith_stores/components/curve.dart';
import 'package:zenith_stores/components/utils/show_snackBar.dart';
import 'package:zenith_stores/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zenith_stores/provider/cart_provider.dart';
import 'package:zenith_stores/screens/otherscrens/checkout_screen.dart';
import 'package:zenith_stores/screens/productdetails/chat_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outPutDateFormate.format(date);

    return outPutDate;
  }

  int _imageIndex = 0;
  String? _selectedSize;
  bool favorite = false;
  int quantity = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    int remains = widget.productData['imageUrl'].length.toInt() ?? 1;
    // Set up a timer to change the image every 5 seconds (adjust as needed)
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _imageIndex = (_imageIndex + 1) % remains;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    List<ImageProvider> allImages = [
      ...widget.productData['imageUrl'].map((url) => NetworkImage(url)),
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kDarkGreenColor,
        elevation: 0,
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: ImageSliderScreen(
                imageUrls: widget.productData['imageUrl']
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 14, left: 14, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatCurrency
                                .format(widget.productData['productPrice']),
                            style: GoogleFonts.oswald(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${widget.productData['quantity']}+ Available",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kDarkredColor, // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(6.0), // Border radius
                            ),
                            child: Center(
                              child: Text(
                                widget.productData['category'],
                                style: TextStyle(
                                    color: kDarkredColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(7),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.redAccent.withOpacity(0.1)
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.account_balance_wallet_outlined, size: 13,),
                            Text("WHOLESALE  2+ pieces over 5% off"),
                          ],),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade300
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Icon(Icons.account_balance_wallet_outlined),
                          Text("Get NGN2,300.28 off orders over NGN100,000"),
                          Icon(Icons.arrow_forward_ios),
                        ],),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.productData['productName'],
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.productData['description'],
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return Container(
                                width: 25,
                                height: 25,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      // Set the rating when a star is pressed
                                      _rating = index + 1;
                                    });
                                  },
                                  icon: Icon(
                                    index < _rating ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                  ),
                                ),
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '$_rating.0',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: ' | 134 Sold',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Available Size',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        height: 50,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.productData['sizeList'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: _selectedSize ==
                                      widget.productData['sizeList']
                                      [index]
                                      ? kDarkGreenColor
                                      : null,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedSize = widget
                                            .productData['sizeList'][index];
                                      });

                                      print(_selectedSize);
                                    },
                                    child: Text(
                                      widget.productData['sizeList'][index],
                                      style: GoogleFonts.poppins(
                                        color: _selectedSize ==
                                            widget.productData['sizeList']
                                            [index]
                                            ? Colors.white
                                            : kDarkGreenColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ChatScreen(
                            userId: widget.productData['vendorId'])));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'images/mes.png',
                        width: 20,
                      ),
                      Text('Message',
                          style: GoogleFonts.poppins(
                              color: kDarkGreenColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12)),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _cartProvider.getCartItem
                          .containsKey(widget.productData['productId'])
                          ? null
                          : () {
                        if (_selectedSize == null) {
                          return showSnack(context, 'Please Select A Size');
                        } else {
                          _cartProvider.addProductToCart(
                              widget.productData['productName'],
                              widget.productData['productId'],
                              widget.productData['imageUrl'],
                              1,
                              widget.productData['quantity'],
                              widget.productData['productPrice'],
                              widget.productData['vendorId'],
                              _selectedSize!,
                              widget.productData['scheduleDate']);
                         showSnack(context,
                              'You Added ${widget.productData['productName']} To Your Cart');
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return CheckoutScreen();
                          }));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 45,
                        decoration: BoxDecoration(
                          color: _cartProvider.getCartItem
                              .containsKey(widget.productData['productId'])
                              ? Colors.grey
                              : kGinColor,
                          borderRadius: BorderRadius.horizontal(left:Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Image.asset(
                                'images/bag.png',
                                width: 20,color: _cartProvider.getCartItem
                                  .containsKey(widget.productData['productId'])
                                  ? Colors.white
                                  :kDarkGreenColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: _cartProvider.getCartItem
                                  .containsKey(widget.productData['productId'])
                                  ? Text(
                                'Buy now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                                  : Text(
                                'Buy now',
                                style: TextStyle(
                                  color: kDarkGreenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: _cartProvider.getCartItem
                              .containsKey(widget.productData['productId'])
                          ? null
                          : () {
                              if (_selectedSize == null) {
                                return showSnack(context, 'Please Select A Size');
                              } else {
                                _cartProvider.addProductToCart(
                                    widget.productData['productName'],
                                    widget.productData['productId'],
                                    widget.productData['imageUrl'],
                                    1,
                                    widget.productData['quantity'],
                                    widget.productData['productPrice'],
                                    widget.productData['vendorId'],
                                    _selectedSize!,
                                    widget.productData['scheduleDate']);

                                return showSnack(context,
                                    'You Added ${widget.productData['productName']} To Your Cart');
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 45,
                        decoration: BoxDecoration(
                          color: _cartProvider.getCartItem
                                  .containsKey(widget.productData['productId'])
                              ? Colors.grey.shade700
                              : kDarkGreenColor,
                          borderRadius: BorderRadius.horizontal(right:Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Image.asset(
                                'images/cart.png',
                                width: 20, color: _cartProvider.getCartItem
                                  .containsKey(widget.productData['productId'])
                                  ? Colors.white
                                  :Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: _cartProvider.getCartItem
                                      .containsKey(widget.productData['productId'])
                                  ? Expanded(
                                    child: Text(
                                        'In Cart',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                ),
                                      ),
                                  )
                                  : Expanded(
                                    child: Text(
                                        'Add to cart',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                  ),
                            )
                          ],
                        ),
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
}

class PlantMetricsWidget extends StatelessWidget {
  const PlantMetricsWidget({
    required this.title,
    required this.value,
    required this.icon,
    Key? key,
  }) : super(key: key);

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      padding: const EdgeInsets.only(right: 28.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kDarkGreenColor,
            radius: 28.0,
            child: Icon(
              icon,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: kGreyColor,
                ),
              ),
              Align(
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreenColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatefulWidget {
  const QuantitySelector({
    required this.min,
    required this.max,
    required this.initial,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final int min;
  final int max;
  final int initial;
  final Function(int) onChanged;

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int quantity;

  @override
  void initState() {
    quantity = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.0,
      width: 95.0,
      decoration: BoxDecoration(
        color: kDarkGreenColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.onChanged(
                      quantity != widget.min ? --quantity : widget.min);
                });
              },
              child: const Icon(
                Icons.remove,
                color: Colors.white,
                size: 18.0,
              ),
            ),
          ),
          Align(
            child: Text(
              '$quantity',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.onChanged(
                      quantity != widget.max ? ++quantity : widget.max);
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int scale;
  final double stars;
  final Color? color;
  final double? size;
  final Function(double)? onChanged;

  const StarRating({
    this.scale = 5,
    this.stars = 0.0,
    this.size,
    this.color = Colors.orange,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  Widget buildStar(BuildContext context, int index) {
    IconData icon;
    if (index >= stars) {
      icon = Icons.star_border;
    } else if (index > stars - 1 && index < stars) {
      icon = Icons.star_half;
    } else {
      icon = Icons.star;
    }
    return GestureDetector(
      onTap: () => onChanged!(index + 1.0),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        scale,
        (index) => buildStar(context, index),
      ),
    );
  }
}
