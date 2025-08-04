// import '../../domain/entities/user.dart';

// class UserModel extends User {
//   const UserModel({
//     required super.login,
//     required super.id,
//     required super.avatarUrl,
//     required super.htmlUrl,
//   });
  
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       login: json['login'] ?? '',
//       id: json['id'] ?? 0,
//       avatarUrl: json['avatar_url'] ?? '',
//       htmlUrl: json['html_url'] ?? '',
//     );
//   }
  
//   Map<String, dynamic> toJson() {
//     return {
//       'login': login,
//       'id': id,
//       'avatar_url': avatarUrl,
//       'html_url': htmlUrl,
//     };
//   }
// }

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.login,
    required super.id,
    required super.avatarUrl,
    required super.htmlUrl,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      login: json['login']?.toString() ?? '',
      id: _parseIntSafely(json['id']),
      avatarUrl: json['avatar_url']?.toString() ?? '',
      htmlUrl: json['html_url']?.toString() ?? '',
    );
  }
  
  static int _parseIntSafely(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'id': id,
      'avatar_url': avatarUrl,
      'html_url': htmlUrl,
    };
  }
}
