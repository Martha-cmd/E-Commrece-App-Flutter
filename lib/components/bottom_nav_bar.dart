import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTapped,
    required this.items,
  }) : super(key: key);

  final int selectedIndex;
  final Color selectedColor;
  final Color unselectedColor;
  final Function(int) onTapped;
  final List<Icon> items;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      height: 70.0,
      // margin: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,

        // borderRadius: BorderRadius.circular(40.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(-3, -1),
            color: Colors.grey.shade300,
            blurRadius: 100.0,
            spreadRadius: 1,
          ),

        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < items.length; i++)
              IconButton(
                icon: items[i],
                iconSize: 25.0,
                color: selectedIndex == i ? selectedColor : unselectedColor,
                onPressed: () {
                  onTapped(i);
                },
              ),
          ],
        ),
      ),
    );
  }
}
