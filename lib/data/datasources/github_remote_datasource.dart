import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/pull_request_model.dart';

abstract class GitHubRemoteDataSource {
  Future<List<PullRequestModel>> getPullRequests(String owner, String repo);
}

class GitHubRemoteDataSourceImpl implements GitHubRemoteDataSource {
  final ApiClient apiClient;
  
  GitHubRemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<List<PullRequestModel>> getPullRequests(String owner, String repo) async {
    final endpoint = '/repos/$owner/$repo/pulls';
    
    if (kDebugMode) {
      print('DataSource: Making request to endpoint: $endpoint');
    }
    
    try {
      final response = await apiClient.getList(endpoint);
      
      if (kDebugMode) {
        print('DataSource: Received ${response.length} items from API');
      }
      
      final pullRequests = response
          .map<PullRequestModel>((json) {
            try {
              return PullRequestModel.fromJson(json);
            } catch (e) {
              if (kDebugMode) {
                print('Error parsing PR JSON: $e');
                print('Problematic JSON: $json');
              }
              rethrow;
            }
          })
          .toList();
      
      if (kDebugMode) {
        print('DataSource: Successfully parsed ${pullRequests.length} pull requests');
      }
      
      return pullRequests;
    } catch (e) {
      if (kDebugMode) {
        print('DataSource Error: $e');
      }
      rethrow;
    }
  }
}
