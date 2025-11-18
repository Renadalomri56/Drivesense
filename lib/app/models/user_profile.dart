enum UserRole {
  driver,
  admin;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
          (e) => e.name == role,
      orElse: () => UserRole.driver,
    );
  }
}

class UserProfile {
  final String userId;
  final String name;
  final String phone;
  final String imageLink;
  final UserRole role;
  final List<String> devices;
  final Map<String, dynamic> preferredSettings;

  UserProfile({
    required this.userId,
    required this.name,
    required this.phone,
    required this.imageLink,
    required this.role,
    List<String>? devices,
    Map<String, dynamic>? preferredSettings,
  })  : devices = devices ?? [],
        preferredSettings = preferredSettings ?? {};

  // From JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      imageLink: json['image_link'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'user'),
      devices: List<String>.from(json['devices'] ?? []),
      preferredSettings: Map<String, dynamic>.from(json['preferred_settings'] ?? {}),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'phone': phone,
      'image_link': imageLink,
      'role': role.name,
      'devices': devices,
      'preferred_settings': preferredSettings,
    };
  }

  // From Firestore
  factory UserProfile.fromFirestore(Map<String, dynamic> data, String id) {
    return UserProfile(
      userId: id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      imageLink: data['image_link'] ?? '',
      role: UserRole.fromString(data['role'] ?? 'user'),
      devices: List<String>.from(data['devices'] ?? []),
      preferredSettings: Map<String, dynamic>.from(data['preferred_settings'] ?? {}),
    );
  }

  // To Firestore
  static Map<String, dynamic> toFirestore(UserProfile profile) {
    return {
      'name': profile.name,
      'phone': profile.phone,
      'image_link': profile.imageLink,
      'role': profile.role.name,
      'devices': profile.devices,
      'preferred_settings': profile.preferredSettings,
    };
  }

  UserProfile copyWith({
    String? userId,
    String? name,
    String? phone,
    String? imageLink,
    UserRole? role,
    List<String>? devices,
    Map<String, dynamic>? preferredSettings,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      imageLink: imageLink ?? this.imageLink,
      role: role ?? this.role,
      devices: devices ?? this.devices,
      preferredSettings: preferredSettings ?? this.preferredSettings,
    );
  }
}