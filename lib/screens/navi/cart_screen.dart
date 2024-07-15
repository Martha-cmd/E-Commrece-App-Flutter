import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenith_stores/constants.dart';
import 'package:intl/intl.dart';
import 'package:zenith_stores/models/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:zenith_stores/provider/cart_provider.dart';
import 'package:zenith_stores/screens/main_screen.dart';
import 'package:zenith_stores/screens/otherscrens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  static String id = "CartScreen";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double subTotal = 0;
  double shippingCost = 50.0;
  bool _loading = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);

    // This is the AppBar
    AppBar appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0.0,
      leadingWidth: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Cart',
            style: GoogleFonts.poppins(
              color: kDarkGreenColor,
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _cartProvider.removeAllItem();
          },
          child: Row(
            children: [
              Text('Clear All', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w700)),
              Icon(Icons.delete, color: Colors.red, size: 16,),
            ],
          ),
        )
      ],
    );

    final formatCurrency =
    NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    double appbarHeight = appBar.preferredSize.height;
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    double mainHeight =
        MediaQuery.of(context).size.height - appbarHeight - bottomPadding;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 7,
              child: _cartProvider.getCartItem.isNotEmpty
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        height: mainHeight * 7 / 11 - 30,
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 20.0, right: 20.0, bottom: 50),
                        child: ListView.builder(
                          itemCount: _cartProvider.getCartItem.length,
                          itemBuilder: (context, index) {
                            final cartData = _cartProvider.getCartItem.values
                                .toList()[index];
                            return Container(
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: kGinColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 80.0,
                                    width: 80.0,
                                    margin: const EdgeInsets.only(right: 15.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          cartData.imageUrl[0],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // The First Widget
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cartData.productName,
                                              style: GoogleFonts.poppins(
                                                color: kDarkGreenColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            IconButton(
                                              constraints: BoxConstraints(),
                                              padding: EdgeInsets.all(0),
                                              onPressed: () {
                                                _cartProvider.removeItem(
                                                  cartData.productId,
                                                );
                                              },
                                              icon: Icon(
                                                Icons.remove_shopping_cart_rounded,
                                              ),
                                            ),

                                          ],
                                        ),

                                        // The info about the plant
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 6.0),
                                          child: Text(
                            formatCurrency.format(cartData.price),
                                            style: GoogleFonts.oswald(
                                              color: kGreyColor,
                                            ),
                                          ),
                                        ),

                                        // The third widget
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // This is Quantity Selector
                                            Row(
                                              children: [
                                                Container(
                                                  height: 22.0,
                                                  width: 24.0,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1.0,
                                                      color: kDarkGreenColor,
                                                    ),
                                                    borderRadius: BorderRadius.circular(6.0),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: cartData.quantity == 1
                                                        ? null
                                                        : () {
                                                      _cartProvider
                                                          .decreaMent(cartData);
                                                    },
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 14.0,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                  width: 31.0,
                                                  child: Text(
                                                    cartData.quantity.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      color: kDarkGreenColor,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 22.0,
                                                  width: 24.0,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1.0,
                                                      color: kDarkGreenColor,
                                                    ),
                                                    borderRadius: BorderRadius.circular(6.0),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: cartData.productQuantity ==
                                                        cartData.quantity
                                                        ? null
                                                        : () {
                                                      _cartProvider
                                                          .increament(cartData);
                                                    },
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 14.0,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),

                                            // Shows Total Price of the plant according to the quantity
                                            Text(
                                              formatCurrency.format(_cartProvider.totalPrice),
                                              style: GoogleFonts.oswald(
                                                color: Colors.green.shade600,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.0,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'Your Shopping Cart is Empty',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return MainScreen();
                              }));
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                color: kDarkGreenColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Continue Shopping',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Flexible(
              flex: 4,
              child: Container(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(-1, -6),
                      color: Colors.black12,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal:',
                                style: kBillTextStyle,
                              ),
                              Text(
                                formatCurrency.format(_cartProvider.totalPrice),
                                style: GoogleFonts.oswald(
                                  color: kDarkGreenColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6.0),
                        ],
                      ),
                    ),
                    Container(height: 0.5, color: Colors.grey.shade500),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: GoogleFonts.poppins(
                              color: kDarkGreenColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            formatCurrency.format( _cartProvider.totalPrice),
                            style: GoogleFonts.oswald(
                              color: kDarkGreenColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: _cartProvider.totalPrice == 0.00
                            ? Colors.grey
                            : kDarkGreenColor,
                        elevation: 20.0,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      onPressed:
                          _cartProvider.totalPrice == 0.00 ? null : () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return CheckoutScreen();
                            }));
                          },
                      child: const Text('Place Your Order'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemCard extends StatefulWidget {
  const CartItemCard({
    required this.item,
    required this.onQuantityChanged,
    Key? key,
  }) : super(key: key);

  final CartAttr item;
  final Function(int) onQuantityChanged;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Container(
      height: 100.0,
      decoration: BoxDecoration(
        color: kGinColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            height: 80.0,
            width: 80.0,
            margin: const EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(
                  widget.item.imageUrl[0],
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // The First Widget
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.item.productName,
                      style: GoogleFonts.poppins(
                        color: kDarkGreenColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        _cartProvider.removeItem(
                          widget.item.productId,
                        );
                      },
                      icon: Icon(
                        Icons.remove_shopping_cart_rounded,
                      ),
                    ),

                  ],
                ),

                // The info about the plant
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text(
                    '${widget.item.price}',
                    style: GoogleFonts.poppins(
                      color: kGreyColor,
                    ),
                  ),
                ),

                // The third widget
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // This is Quantity Selector
                    Row(
                      children: [
                        Container(
                          height: 22.0,
                          width: 24.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: kDarkGreenColor,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: GestureDetector(
                            onTap: widget.item.quantity == 1
                                ? null
                                : () {
                              _cartProvider
                                  .decreaMent(widget.item);
                            },
                            child: Icon(
                              Icons.remove,
                              size: 14.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          width: 31.0,
                          child: Text(
                            widget.item.quantity.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: kDarkGreenColor,
                            ),
                          ),
                        ),
                        Container(
                          height: 22.0,
                          width: 24.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: kDarkGreenColor,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: GestureDetector(
                            onTap: widget.item.productQuantity ==
                                widget.item.quantity
                                ? null
                                : () {
                              _cartProvider
                                  .increament(widget.item);
                            },
                            child: Icon(
                              Icons.add,
                              size: 14.0,
                            ),
                          ),
                        )
                      ],
                    ),

                    // Shows Total Price of the plant according to the quantity
                    Text(
                      'N${_cartProvider.totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget quantityButton(
      {required IconData icon, required Function() onPressed}) {
    return Container(
      height: 22.0,
      width: 24.0,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: kDarkGreenColor,
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Icon(
          icon,
          size: 14.0,
        ),
      ),
    );
  }
}
