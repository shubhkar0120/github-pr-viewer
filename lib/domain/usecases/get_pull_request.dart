import '../entities/pull_request.dart';
import '../repositories/github_repository.dart';

class GetPullRequests {
  final GitHubRepository repository;
  
  GetPullRequests(this.repository);
  
  Future<List<PullRequest>> call(String owner, String repo) async {
    return await repository.getPullRequests(owner, repo);
  }
}
