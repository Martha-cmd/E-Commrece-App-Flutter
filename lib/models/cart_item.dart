import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:zenith_stores/models/plant.dart';

class CartItem {
  final Plant plant;
  int quantity;

  CartItem(this.plant, this.quantity);
}

class CartAttr with ChangeNotifier {
  final String productName;

  final String productId;

  final List imageUrl;

  int quantity;

  int productQuantity;

  final double price;

  final String vendorId;

  final String productSize;

  Timestamp scheduleDate;

  CartAttr(
      {required this.productName,
        required this.productId,
        required this.imageUrl,
        required this.quantity,

        required this.productQuantity,
        required this.price,
        required this.vendorId,
        required this.productSize,
        required this.scheduleDate});

  void increase() {
    quantity++;
  }

  void decrease() {
    quantity--;
  }
}
