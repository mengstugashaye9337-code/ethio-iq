import 'package:ethio_iq/core/constants/app_constants.dart';
import 'package:ethio_iq/core/models/user_model.dart';

/// In-memory authentication service for login/register validation.
///
/// Stores registered users in memory during the app session and
/// keeps the current authenticated user for dashboard navigation.
class AuthService {
  static const String adminSecretCode = 'ETHIO_ADMIN_2026';

  static final List<UserModel> _registeredUsers = [];
  static UserModel? _currentUser;
  static bool _isAuthenticated = false;

  static UserModel? getCurrentUser() => _currentUser;

  static bool isAuthenticated() => _isAuthenticated;

  static List<UserModel> get registeredUsers => List.unmodifiable(_registeredUsers);

  static void registerUser({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required UserRole role,
  }) {
    final user = UserModel(
      id: phoneNumber,
      name: name,
      email: email,
      role: role,
      phoneNumber: phoneNumber,
      registrationDate: DateTime.now(),
      appliedAt: role == UserRole.tutor ? DateTime.now() : null,
      password: password,
      verificationStatus: role == UserRole.tutor
          ? VerificationStatus.pending
          : null,
    );

    _registeredUsers.add(user);
    _currentUser = user;
    _isAuthenticated = true;
  }

  static UserModel login({required String phoneNumber, required String password}) {
    if (password == adminSecretCode) {
      if (phoneNumber.isEmpty) {
        throw Exception('Enter a phone number to sign in as admin.');
      }
      final admin = UserModel(
        id: 'admin_$phoneNumber',
        name: 'Administrator',
        email: 'admin@ethio-iq.com',
        role: UserRole.admin,
        phoneNumber: phoneNumber,
        password: password,
        registrationDate: DateTime.now(),
      );
      _currentUser = admin;
      _isAuthenticated = true;
      return admin;
    }

    final user = _registeredUsers.firstWhere(
      (user) => user.phoneNumber == phoneNumber && user.password == password,
      orElse: () {
        throw Exception('Account not found. Please register first.');
      },
    );

    _currentUser = user;
    _isAuthenticated = true;
    return user;
  }

  static void updateUser(UserModel updatedUser) {
    final index = _registeredUsers.indexWhere(
      (user) => user.id == updatedUser.id,
    );
    if (index != -1) {
      _registeredUsers[index] = updatedUser;
    } else {
      _registeredUsers.add(updatedUser);
    }

    if (_currentUser?.id == updatedUser.id) {
      _currentUser = updatedUser;
    }
  }

  static Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
