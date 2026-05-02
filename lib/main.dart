import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(const EthioIQApp());
}

/// Ethio IQ Main Application
/// 
/// Initializes AppTheme.themeData for Material 3 consistency
class EthioIQApp extends StatelessWidget {
  const EthioIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethio IQ',
      debugShowCheckedModeBanner: false,
      
      // ============================================
      // THEME INITIALIZATION
      // ============================================
      /// AppTheme.themeData applies:
      /// - Material 3 design system
      /// - Primary blue color scheme
      /// - Consistent card, button, input decorations
      theme: AppTheme.themeData,
      
      // Start with LoginScreen - user enters name → navigates to Dashboard
      home: const LoginScreen(),
    );
  }
}
