import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/features/auth/data/user_model.dart';

/// Auth Service - manages user authentication state
/// 
/// DATA FLOW EXPLANATION:
/// 1. User enters credentials in LoginScreen
/// 2. login() is called → calls UserModel.login() 
/// 3. On success, user data is stored in _currentUser
/// 4. getCurrentUser() exposes the user to other screens
/// 5. DashboardScreen calls getCurrentUser() to display "Selam, Mengstu!"
class AuthService {
  static UserModel? _currentUser;
  static bool _isAuthenticated = false;

  /// Get the currently logged-in user
  static UserModel? getCurrentUser() => _currentUser;

  /// Check if user is authenticated
  static bool isAuthenticated() => _isAuthenticated;

  /// Login with email and password
  /// Returns the UserModel on success, throws exception on failure
  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Call the UserModel's static login method
      // In a real app, this would make an API call
      final user = await UserModel.login(email, password);
      
      // Store the user in memory (in real app, use secure storage)
      _currentUser = user;
      _isAuthenticated = true;
      
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Logout and clear user data
  static Future<void> logout() async {
    await UserModel.logout();
    _currentUser = null;
    _isAuthenticated = false;
  }
}

/// Simple Login Screen demonstrating the data flow
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // DATA FLOW: Here we call AuthService.login()
      // which internally calls UserModel.login()
      // On success, the user "Mengstu" is stored in AuthService
      final user = await AuthService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        // Navigate to Dashboard - user data flows via AuthService
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => DashboardScreen(user: user),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              
              // Email Field
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppTheme.spacingL),
              
              // Password Field
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outlined),
                ),
                obscureText: true,
              ),
              const SizedBox(height: AppTheme.spacingXL),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Import DashboardScreen - will be created next
// Placeholder import - actual import will work once file exists
class DashboardScreen extends StatelessWidget {
  final UserModel user;
  
  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Ethio IQ',
          style: AppTheme.titleMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingStandard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================
            // GREETING SECTION - Data flows here!
            // ============================================
            // 1. LoginScreen passes `user` to DashboardScreen
            // 2. We use user.name to display the greeting
            // 3. "Selam" is the Ethiopian greeting from AppConstants
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              decoration: AppTheme.softBlueGradient.toBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selam, ${user.name}!', // ← Data flows: user.name
                    style: AppTheme.titleLarge.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Welcome to your learning journey',
                    style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),
            
            // ============================================
            // TUTOR OVERVIEW SECTION
            // ============================================
            Text(
              'Tutor Overview',
              style: AppTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            // Using whiteCardDecoration as requested
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingStandard),
              decoration: AppTheme.whiteCardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        decoration: AppTheme.cardDecoration,
                        child: const Icon(
                          Icons.school,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingL),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Tutors',
                              style: AppTheme.titleSmall,
                            ),
                            Text(
                              'Find your perfect tutor',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            // Quick Stats Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingStandard),
              decoration: AppTheme.whiteCardDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('12', 'Tutors'),
                  _buildStatItem('5', 'Subjects'),
                  _buildStatItem('3', 'Bookings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.titleLarge.copyWith(color: AppTheme.primaryBlue),
        ),
        Text(
          label,
          style: AppTheme.bodySmall,
        ),
      ],
    );
  }
}

// Extension to convert Gradient to BoxDecoration
extension GradientExtension on LinearGradient {
  BoxDecoration toBoxDecoration() {
    return BoxDecoration(
      gradient: this,
      borderRadius: BorderRadius.circular(12),
    );
  }
}