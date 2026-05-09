import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/core/extensions/gradient_extension.dart';
import 'package:ethio_iq/features/auth/presentation/screens/registration_screen.dart';
import 'package:ethio_iq/core/constants/app_constants.dart';
import 'package:ethio_iq/features/auth/data/auth_service.dart';
import 'package:ethio_iq/features/dashboard/presentation/screens/admin_dashboard.dart';
import 'package:ethio_iq/features/dashboard/presentation/screens/family_dashboard.dart';
import 'package:ethio_iq/features/dashboard/presentation/screens/tutor_dashboard.dart';

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
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  /// Handle login using registered accounts
  Future<void> _handleLogin() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your phone number and password',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = AuthService.login(phoneNumber: phone, password: password);

      if (!mounted) return;

      Widget dashboard;
      switch (user.role) {
        case UserRole.family:
          dashboard = FamilyDashboard(user: user);
          break;
        case UserRole.tutor:
          dashboard = TutorDashboard(user: user);
          break;
        case UserRole.admin:
          dashboard = AdminDashboard(user: user);
          break;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => dashboard),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account not found. Please register first.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Navigate to registration screen
  void _navigateToRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationScreen()),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingStandard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppTheme.spacingL),

              // App Logo/Title
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingXL),
                decoration: AppTheme.softBlueGradient.toBoxDecoration(),
                child: const Icon(Icons.school, color: Colors.white, size: 64),
              ),
              const SizedBox(height: AppTheme.spacingXL),

              Text(
                'Ethio IQ',
                style: AppTheme.titleLarge.copyWith(
                  color: AppTheme.primaryBlue,
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                'Your Gateway to Quality Education',
                style: AppTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXXL),

              // Phone Input Field
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: AppTheme.bodyMedium,
                  hintText: 'Enter your phone number',
                  hintStyle: AppTheme.bodySmall,
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
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
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppTheme.spacingL),

              // Password Input Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: AppTheme.bodyMedium,
                  hintText: 'Enter your password',
                  hintStyle: AppTheme.bodySmall,
                  prefixIcon: const Icon(
                    Icons.lock_outlined,
                    color: AppTheme.textSecondary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
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
                obscureText: _obscurePassword,
              ),
              const SizedBox(height: AppTheme.spacingXL),

              // Login Button
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
                      : Text('Login', style: AppTheme.buttonText),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),

              // Footer
              Text(
                'Ethiopian Education Platform',
                style: AppTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXXL),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: AppTheme.bodyMedium),
                  GestureDetector(
                    onTap: () => _navigateToRegistration(context),
                    child: Text(
                      'Sign Up',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}

// Remove duplicate extension - using shared one in core/extensions/
