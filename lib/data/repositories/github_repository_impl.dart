import 'package:flutter/foundation.dart';
import '../../domain/entities/pull_request.dart';
import '../../domain/repositories/github_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/github_remote_datasource.dart';

class GitHubRepositoryImpl implements GitHubRepository {
  final GitHubRemoteDataSource remoteDataSource;
  
  GitHubRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<List<PullRequest>> getPullRequests(String owner, String repo) async {
    if (kDebugMode) {
      print('Repository: Fetching PRs for $owner/$repo');
    }
    
    try {
      if (owner.isEmpty || repo.isEmpty) {
        throw const NetworkFailure('Repository owner and name cannot be empty');
      }
      
      final pullRequestModels = await remoteDataSource.getPullRequests(owner, repo);
      
      if (kDebugMode) {
        print('Repository: Received ${pullRequestModels.length} raw PR models');
      }
      
      // Filter out any invalid pull requests
      final validPullRequests = pullRequestModels
          .where((pr) => pr.id > 0 && pr.number > 0)
          .toList();
      
      if (kDebugMode) {
        print('Repository: Filtered to ${validPullRequests.length} valid PRs');
      }
      
      return validPullRequests;
    } catch (e) {
      if (kDebugMode) {
        print('Repository Error: $e');
        print('Error Type: ${e.runtimeType}');
      }
      
      if (e is Failure) {
        rethrow;
      }
      throw NetworkFailure('Failed to fetch pull requests: ${e.toString()}');
    }
  }
}
