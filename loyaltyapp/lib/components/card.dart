import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget card() {
  return Container(
    margin: EdgeInsets.all(10),
    height: 250,
    width: 200,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          'https://via.placeholder.com/50', // replace with your PNG URL
          height: 50,
          width: 50,
        ),
        SizedBox(height: 10),
        Text(
          "Welcome",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 10),
        Image.network(
          'https://via.placeholder.com/50', // replace with your PNG URL
          height: 50,
          width: 50,
        ),
      ],
    ),
  );
}