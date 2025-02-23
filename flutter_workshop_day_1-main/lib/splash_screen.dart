import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_basics/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "Flutter Demo")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("GDG KJSCE"))
    );
  }
}