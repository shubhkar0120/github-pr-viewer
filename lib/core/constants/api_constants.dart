class ApiConstants {
  static const String baseUrl = 'https://api.github.com';
  static const String pullRequestsEndpoint = '/repos/{owner}/{repo}/pulls';
  static const String defaultOwner = 'flutter';
  static const String defaultRepo = 'flutter';
  

  static const String repositoryOwner = 'shubhkar0120';
  static const String repositoryName = 'github-pr-viewer';
  
  static const Map<String, String> headers = {
    'Accept': 'application/vnd.github.v3+json',
    'Content-Type': 'application/json',
    'User-Agent': 'Flutter-GitHub-PR-Viewer',
  };
  

  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}
