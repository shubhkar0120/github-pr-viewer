// import '../../domain/entities/pull_request.dart';
// import '../../core/utils/date_formatter.dart';
// import 'user_model.dart';

// class PullRequestModel extends PullRequest {
//   const PullRequestModel({
//     required super.id,
//     required super.number,
//     required super.title,
//     required super.body,
//     required super.state,
//     required super.htmlUrl,
//     required super.createdAt,
//     required super.updatedAt,
//     required super.user,
//   });
  
//   factory PullRequestModel.fromJson(Map<String, dynamic> json) {
//     return PullRequestModel(
//       id: json['id'] ?? 0,
//       number: json['number'] ?? 0,
//       title: json['title'] ?? '',
//       body: json['body'] ?? '',
//       state: json['state'] ?? '',
//       htmlUrl: json['html_url'] ?? '',
//       createdAt: DateFormatter.parseIsoDate(json['created_at']),
//       updatedAt: DateFormatter.parseIsoDate(json['updated_at']),
//       user: UserModel.fromJson(json['user'] ?? {}),
//     );
//   }
  
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'number': number,
//       'title': title,
//       'body': body,
//       'state': state,
//       'html_url': htmlUrl,
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//       'user': (user as UserModel).toJson(),
//     };
//   }
// }

import '../../domain/entities/pull_request.dart';
import '../../core/utils/date_formatter.dart';
import 'user_model.dart';

class PullRequestModel extends PullRequest {
  const PullRequestModel({
    required super.id,
    required super.number,
    required super.title,
    required super.body,
    required super.state,
    required super.htmlUrl,
    required super.createdAt,
    required super.updatedAt,
    required super.user,
  });
  
  factory PullRequestModel.fromJson(Map<String, dynamic> json) {
    return PullRequestModel(
      id: _parseIntSafely(json['id']),
      number: _parseIntSafely(json['number']),
      title: json['title']?.toString() ?? 'No Title',
      body: json['body']?.toString() ?? '',
      state: json['state']?.toString() ?? 'unknown',
      htmlUrl: json['html_url']?.toString() ?? '',
      createdAt: DateFormatter.parseIsoDate(json['created_at']?.toString()),
      updatedAt: DateFormatter.parseIsoDate(json['updated_at']?.toString()),
      user: _parseUserSafely(json['user']),
    );
  }
  
  static int _parseIntSafely(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
  
  static UserModel _parseUserSafely(dynamic userData) {
    if (userData == null || userData is! Map<String, dynamic>) {
      return const UserModel(
        login: 'unknown',
        id: 0,
        avatarUrl: '',
        htmlUrl: '',
      );
    }
    return UserModel.fromJson(userData);
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'body': body,
      'state': state,
      'html_url': htmlUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user': (user as UserModel).toJson(),
    };
  }
}
