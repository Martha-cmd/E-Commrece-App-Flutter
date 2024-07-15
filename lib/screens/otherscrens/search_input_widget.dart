import 'package:flutter/material.dart';
import 'package:zenith_stores/constants.dart';

class SearchInputWidget extends StatelessWidget {
  const SearchInputWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        ),
      ),
    );
  }
}
