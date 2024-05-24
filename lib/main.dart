// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:password/password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      title: 'Password Generator',
      home: const PasswordGenerator(),
    );
  }
}