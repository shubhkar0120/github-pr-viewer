abstract class Failure {
  final String message;
  const Failure(this.message);
  
  @override
  String toString() => message;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
  
  @override
  String toString() => 'Network Error: $message';
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
  
  @override
  String toString() => 'Server Error: $message';
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
  
  @override
  String toString() => 'Cache Error: $message';
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
  
  @override
  String toString() => 'Auth Error: $message';
}
