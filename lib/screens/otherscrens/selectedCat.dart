// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:zenith_stores/constants.dart';
// import 'package:zenith_stores/data.dart';
// import 'package:zenith_stores/screens/navi/home_screen.dart';
//
// class SeletecategoryScreen extends StatefulWidget {
//   static const String id = 'selectScreen';
//   final String categoryName;
//   const SeletecategoryScreen({super.key, required this.categoryName});
//
//   @override
//   _SeletecategoryScreenState createState() => _SeletecategoryScreenState();
// }
//
// class _SeletecategoryScreenState extends State<SeletecategoryScreen> with SingleTickerProviderStateMixin{
//   TabController? _tabController;
//
//   // final List<Plant> allItem = []; // Initialize with your data
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 7, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController?.dispose();
//     super.dispose();
//   }
//
//   Widget buildTabView() {
//     return GridView.builder(
//       physics: ScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: allItem.length,
//       itemBuilder: (ctx, index) {
//         return PlantsCard(
//           plantType: allItem[index].plantType,
//           plantName: allItem[index].plantName,
//           plantPrice: allItem[index].plantPrice,
//           image: Image.asset(
//             allItem[index].image,
//             alignment: Alignment.topLeft,
//             width: 160,
//           ),
//           onTap: () {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) {
//             //       return ProductDetailScreen(
//             //         plant: allItem[index],
//             //       );
//             //     },
//             //   ),
//             // );
//           },
//         );
//       },
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: MediaQuery.of(context).size.width /
//             (MediaQuery.of(context).size.height / 1.3),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor:kDarkGreenColor ,
//         title: Text('Category Name',style: GoogleFonts.poppins(
//           color: kDarkGreenColor,
//           fontSize: 20.0,
//           fontWeight: FontWeight.w500,
//         ),),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
//               child: TextField(
//                 style: TextStyle(color: kDarkGreenColor),
//                 cursorColor: kDarkGreenColor,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: kGinColor,
//                   hintText: 'Search outfit',
//                   hintStyle: TextStyle(color: kGreyColor),
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: kDarkGreenColor,
//                     size: 26.0,
//                   ),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.mic),
//                     color: kDarkGreenColor,
//                     iconSize: 26.0,
//                     splashRadius: 20.0,
//                     onPressed: () {},
//                   ),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: kGinColor),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: kGinColor),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: kGinColor),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: buildTabView(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
