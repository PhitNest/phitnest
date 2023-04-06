import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'PhitNest Admin',
    theme: ThemeData(
      primarySwatch: Colors.grey,
      useMaterial3: true,
    ),
    home: Scaffold(
      body: Container(
        child: Text('PhitNest Admin'),
      ),
    ),
  ));
}
