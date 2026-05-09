import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/core/extensions/gradient_extension.dart';
import 'package:ethio_iq/core/constants/app_constants.dart';
import 'package:ethio_iq/core/models/user_model.dart';
import 'package:ethio_iq/features/auth/data/auth_service.dart';
import 'package:ethio_iq/features/dashboard/presentation/screens/family_dashboard.dart';
import 'package:ethio_iq/features/dashboard/presentation/screens/tutor_dashboard.dart';
import 'package:ethio_iq/features/dashboard/presentation/screens/admin_dashboard.dart';

/// Registration Screen - Multi-Role Registration
///
/// Allows users to register as Family, Tutor, or Admin
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _adminKeyController = TextEditingController();
  UserRole _selectedRole = UserRole.family;
  bool _showAdminKeyField = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureAdminKey = true;

  /// Handle registration
  void _handleRegistration() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final secretKey = _adminKeyController.text.trim();

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

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your email',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your phone number',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a password',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (secretKey.isNotEmpty && secretKey != AuthService.adminSecretCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Secret key is invalid',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final role = secretKey == AuthService.adminSecretCode
          ? UserRole.admin
          : _selectedRole;

      AuthService.registerUser(
        name: name,
        email: email,
        phoneNumber: phone,
        password: password,
        role: role,
      );

      final user = AuthService.getCurrentUser();
      if (user != null) {
        _navigateToDashboard(user);
      }
    });
  }

  /// Navigate to the appropriate dashboard based on role
  void _navigateToDashboard(UserModel user) {
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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _adminKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Register', style: AppTheme.titleMedium),
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingStandard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppTheme.paddingLarge),
                decoration: AppTheme.softBlueGradient.toBoxDecoration(),
                child: Row(
                  children: [
                    const Icon(Icons.person_add, color: Colors.white, size: 32),
                    const SizedBox(width: AppTheme.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join Ethio IQ',
                            style: AppTheme.titleLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            'Create your account and start your learning journey',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),

              // Role Selection
              Text('Select Your Role', style: AppTheme.titleMedium),
              const SizedBox(height: AppTheme.spacingL),

              // Role Toggle/Dropdown
              Container(
                padding: const EdgeInsets.all(AppTheme.paddingStandard),
                decoration: AppTheme.whiteCardDecoration,
                child: Column(
                  children: [
                    _buildRoleOption(UserRole.family),
                    const Divider(height: 1),
                    _buildRoleOption(UserRole.tutor),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),

              // Name Input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: AppTheme.bodyMedium,
                  hintText: 'Enter your full name',
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
              const SizedBox(height: AppTheme.spacingL),

              // Email Input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: AppTheme.bodyMedium,
                  hintText: 'Enter your email',
                  hintStyle: AppTheme.bodySmall,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
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
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppTheme.spacingL),

              // Phone Input
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

              // Password Input
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: AppTheme.bodyMedium,
                  hintText: 'Choose a password',
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
              const SizedBox(height: AppTheme.spacingL),

              // Admin Secret Key (Hidden by default)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAdminKeyField = !_showAdminKeyField;
                  });
                },
                child: Text(
                  _showAdminKeyField
                      ? 'Hide admin secret key'
                      : 'Have a secret admin key?',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_showAdminKeyField) ...[
                const SizedBox(height: AppTheme.spacingS),
                TextField(
                  controller: _adminKeyController,
                  decoration: InputDecoration(
                    labelText: 'Secret Admin Key',
                    labelStyle: AppTheme.bodyMedium,
                    hintText: 'Enter admin secret key',
                    hintStyle: AppTheme.bodySmall,
                    prefixIcon: const Icon(
                      Icons.vpn_key_outlined,
                      color: AppTheme.textSecondary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureAdminKey
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppTheme.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureAdminKey = !_obscureAdminKey;
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
                  obscureText: _obscureAdminKey,
                ),
                const SizedBox(height: AppTheme.spacingL),
              ],

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegistration,
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
                      : Text('Create Account', style: AppTheme.buttonText),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),

              // Log In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: AppTheme.bodyMedium),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Log In',
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

  /// Build role selection option
  Widget _buildRoleOption(UserRole role) {
    final isSelected = _selectedRole == role;

    return RadioListTile<UserRole>(
      value: role,
      // ignore: deprecated_member_use
      groupValue: _selectedRole,
      // ignore: deprecated_member_use
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedRole = value;
          });
        }
      },
      activeColor: AppTheme.primaryBlue,
      title: Text(
        role.displayName,
        style: AppTheme.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: isSelected ? AppTheme.primaryBlue : AppTheme.textDark,
        ),
      ),
      subtitle: Text(
        _getRoleDescription(role),
        style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
      ),
    );
  }

  /// Get role description
  String _getRoleDescription(UserRole role) {
    switch (role) {
      case UserRole.family:
        return 'Find and book qualified tutors for your family';
      case UserRole.tutor:
        return 'Offer your teaching services and manage assignments';
      case UserRole.admin:
        return 'Manage platform operations and tutor verification';
    }
  }
}
