/// User model representing authenticated user data
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.createdAt,
  });

  /// Create UserModel from JSON (simulated login response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// Simulated login - in real app, this would call an API
  static Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulated successful login response
    return UserModel(
      id: '1',
      name: 'Mengstu', // Default user as requested
      email: email,
      createdAt: DateTime.now(),
    );
  }

  /// Simulated logout
  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}