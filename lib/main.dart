import 'package:flutter/material.dart';
import 'package:sheshield/googleMap/homemap.dart';
import 'package:sheshield/pages/splashscreen.dart';
import 'package:sheshield/sections/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light, // Set the theme to Light
        primarySwatch: Colors.pink, // Keep the pink accent color
        secondaryHeaderColor: Colors.pink[400],
        scaffoldBackgroundColor: Colors.white, // Set background to white
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pink, // AppBar color
          foregroundColor: Colors.white, // Text & icon color
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Ensure text is black
          bodyLarge: TextStyle(color: Colors.black),
        ),
        cardColor: Colors.white, // Cards background color
        iconTheme: const IconThemeData(
          color: Colors.black,
        ), // Default icon color
      ),
      debugShowCheckedModeBanner: false,
      // home: HomeScreen(),
      // home: Homemap(),
      // home: Conversion(),
      home: SplashScreen(),
    );
  }
}
