/// App-wide constants for Ethio IQ
class AppConstants {
  // ==================== APP INFO ====================

  static const String appName = 'Ethio IQ';
  static const String appTagline = 'Your Gateway to Quality Education';

  // ==================== ETHIOPIAN GREETINGS ====================

  /// Ethiopian greeting based on time of day
  static String getEthiopianGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selam'; // Good morning
    } else if (hour < 18) {
      return 'Selam'; // Good afternoon
    } else {
      return 'Selam'; // Good evening
    }
  }

  // ==================== DEFAULT VALUES ====================

  static const String defaultUser = 'Guest';
  static const int defaultRating = 0;
  static const double defaultPrice = 0.0;

  // ==================== API ENDPOINTS (placeholder) ====================

  static const String baseUrl = 'https://api.ethio-iq.com';
  static const String tutorsEndpoint = '/tutors';
  static const String bookingsEndpoint = '/bookings';
  static const String authEndpoint = '/auth';

  // ==================== LOCAL STORAGE KEYS ====================

  static const String userKey = 'current_user';
  static const String tokenKey = 'auth_token';
  static const String themeKey = 'app_theme';
}

/// User roles in the Ethio IQ platform
enum UserRole {
  family('Family'),
  tutor('Tutor'),
  admin('Admin');

  const UserRole(this.displayName);
  final String displayName;
}
