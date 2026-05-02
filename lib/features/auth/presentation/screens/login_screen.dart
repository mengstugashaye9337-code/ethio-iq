import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/core/extensions/gradient_extension.dart';
import 'package:ethio_iq/features/dashboard/presentation/screens/dashboard_screen.dart';

/// Login Screen - Entry point of the app
/// 
/// DATA FLOW:
/// 1. User enters their name
/// 2. On button press → Navigator.push to DashboardScreen
/// 3. Passes the name as argument to DashboardScreen
/// 4. Dashboard displays "Selam, {name}!"
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  bool _isLoading = false;

  /// Handle login - navigate to Dashboard with name
  void _handleLogin() {
    final name = _nameController.text.trim();
    
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your name',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate brief loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      // ============================================
      // NAVIGATOR.PUSH LOGIC - Moving between folders
      // ============================================
      /// Navigator.push() does:
      /// 1. Takes current screen (LoginScreen) and pushes new route onto stack
      /// 2. Creates DashboardScreen instance with the user's name
      /// 3. Passes data via constructor: DashboardScreen(userName: name)
      /// 4. User can go back with system back button
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(userName: name),
        ),
      ).then((_) {
        // When returning from Dashboard, clear the field
        if (mounted) {
          _nameController.clear();
        }
      });

      setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingStandard),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Title
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingXL),
                decoration: AppTheme.softBlueGradient.toBoxDecoration(),
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),
              
              Text(
                'Ethio IQ',
                style: AppTheme.titleLarge.copyWith(
                  color: AppTheme.primaryBlue,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                'Your Gateway to Quality Education',
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingXXL),
              
              // Name Input Field
              /// Uses AppTheme constants - no hardcoded colors!
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  labelStyle: AppTheme.bodyMedium,
                  hintText: 'Enter your name',
                  hintStyle: AppTheme.bodySmall,
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: AppTheme.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppTheme.backgroundWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryBlue,
                      width: 2,
                    ),
                  ),
                ),
                style: AppTheme.bodyLarge,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: AppTheme.spacingXL),
              
              // Login Button
              /// Uses AppTheme.elevatedButtonStyle - no hardcoded colors!
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: AppTheme.elevatedButtonStyle,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Get Started',
                          style: AppTheme.buttonText,
                        ),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacingXL),
              
              // Footer
              Text(
                'Ethiopian Education Platform',
                style: AppTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Remove duplicate extension - using shared one in core/extensions/