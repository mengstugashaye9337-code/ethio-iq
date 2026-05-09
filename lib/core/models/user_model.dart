import 'package:ethio_iq/core/constants/app_constants.dart';

enum VerificationStatus { pending, active, invited }

/// Unified user model for authentication and role-based dashboards.
class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? phoneNumber;
  final String? password;
  final String? profileImage;
  final DateTime? registrationDate;
  final DateTime? appliedAt;
  final VerificationStatus? verificationStatus;
  final String? cvFileName;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.password,
    this.profileImage,
    this.registrationDate,
    this.appliedAt,
    this.verificationStatus,
    this.cvFileName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (role) => role.name == (json['role'] as String? ?? UserRole.family.name),
        orElse: () => UserRole.family,
      ),
      phoneNumber: json['phoneNumber'] as String?,
      password: json['password'] as String?,
      profileImage: json['profileImage'] as String?,
      registrationDate: json['registrationDate'] != null
          ? DateTime.parse(json['registrationDate'] as String)
          : null,
      appliedAt: json['appliedAt'] != null
          ? DateTime.parse(json['appliedAt'] as String)
          : null,
      verificationStatus: json['verificationStatus'] != null
          ? VerificationStatus.values.firstWhere(
              (status) => status.name == json['verificationStatus'],
              orElse: () => VerificationStatus.pending,
            )
          : null,
      cvFileName: json['cvFileName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'phoneNumber': phoneNumber,
      'password': password,
      'profileImage': profileImage,
      'registrationDate': registrationDate?.toIso8601String(),
      'appliedAt': appliedAt?.toIso8601String(),
      'verificationStatus': verificationStatus?.name,
      'cvFileName': cvFileName,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? phoneNumber,
    String? password,
    String? profileImage,
    DateTime? registrationDate,
    DateTime? appliedAt,
    VerificationStatus? verificationStatus,
    String? cvFileName,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      profileImage: profileImage ?? this.profileImage,
      registrationDate: registrationDate ?? this.registrationDate,
      appliedAt: appliedAt ?? this.appliedAt,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      cvFileName: cvFileName ?? this.cvFileName,
    );
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isTutor => role == UserRole.tutor;
  bool get isFamily => role == UserRole.family;

  static Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: '1',
      name: 'Mengstu',
      email: email,
      role: UserRole.family,
      registrationDate: DateTime.now(),
    );
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
