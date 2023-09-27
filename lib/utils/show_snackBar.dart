import 'package:flutter/material.dart';

showSnackBar(context, String title){
  ScaffoldMessenger.of(context)
  .showSnackBar(
    SnackBar(
      backgroundColor: Colors.yellow.shade800,
      content: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      )
    )
  );
}
