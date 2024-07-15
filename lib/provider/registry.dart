
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zenith_stores/provider/cart_provider.dart';
import 'package:zenith_stores/provider/firebase_provider.dart';
import 'package:zenith_stores/provider/product_provider.dart';


final providers = <SingleChildWidget>[
  ChangeNotifierProvider(create: (_) => ProductProvider()),
  ChangeNotifierProvider(create: (_)=>CartProvider()),
  ChangeNotifierProvider(create: (_)=>FirebaseProvider()),
];
