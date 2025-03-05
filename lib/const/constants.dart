import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color customMustard = Color(0xFFe1ad01);
Color customRed(double opacity) => Color.fromRGBO(225, 1, 1, opacity);
Color backgroundColors = Colors.grey.shade100;

String getDateFormat(String? input) {
  String date;
  late DateTime myDate;

  if (input != null && input.isNotEmpty) {
    myDate = DateTime.parse(
      DateFormat('yyyy-MM-dd').parse(input).toLocal().toString(),
    );

    date = DateFormat("dd MMM, yyyy").format(myDate);
  } else {
    date = '';
  }

  return date;
}

InputDecoration searchInputDecoration(context, String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: Theme.of(context).textTheme.labelSmall,
    prefixIcon: const Icon(Icons.search, size: 18),
    prefixIconConstraints: const BoxConstraints(minWidth: 35),
    constraints: BoxConstraints(
      maxHeight: 40,
      maxWidth: MediaQuery.of(context).size.width - 40,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  );
}
