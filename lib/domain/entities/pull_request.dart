import 'user.dart';

class PullRequest {
  final int id;
  final int number;
  final String title;
  final String body;
  final String state;
  final String htmlUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User user;
  
  const PullRequest({
    required this.id,
    required this.number,
    required this.title,
    required this.body,
    required this.state,
    required this.htmlUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PullRequest &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
