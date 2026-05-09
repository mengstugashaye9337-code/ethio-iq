import 'package:flutter/material.dart';
import 'package:ethio_iq/features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1976D2);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ethio IQ',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
