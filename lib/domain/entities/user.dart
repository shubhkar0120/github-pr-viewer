class User {
  final String login;
  final int id;
  final String avatarUrl;
  final String htmlUrl;
  
  const User({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.htmlUrl,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          login == other.login &&
          id == other.id;

  @override
  int get hashCode => login.hashCode ^ id.hashCode;
}
