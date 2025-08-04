import '../entities/pull_request.dart';

abstract class GitHubRepository {
  Future<List<PullRequest>> getPullRequests(String owner, String repo);
}
