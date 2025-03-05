import 'package:flutter/material.dart';

import '../const/constants.dart';

Widget image(BuildContext context, String img) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.25,
      decoration: BoxDecoration(
        color: backgroundColors,
        image: DecorationImage(
          image: AssetImage('images/$img.png'),
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
