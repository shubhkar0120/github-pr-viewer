import 'package:flutter/foundation.dart';
import 'package:github_pr_viewer_app/domain/usecases/get_pull_request.dart';
import '../../domain/entities/pull_request.dart';
import '../../core/errors/failures.dart';
import '../../core/constants/api_constants.dart';

enum GitHubState { initial, loading, loaded, error }

class GitHubProvider with ChangeNotifier {
  final GetPullRequests _getPullRequests;
  
  GitHubState _state = GitHubState.initial;
  List<PullRequest> _pullRequests = [];
  String? _errorMessage;
  
  GitHubProvider({required GetPullRequests getPullRequests})
      : _getPullRequests = getPullRequests;
  
  GitHubState get state => _state;
  List<PullRequest> get pullRequests => _pullRequests;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == GitHubState.loading;
  bool get hasError => _state == GitHubState.error;
  
  Future<void> fetchPullRequests({
    String? owner,
    String? repo,
  }) async {
    try {
      _state = GitHubState.loading;
      _errorMessage = null;
      notifyListeners();
      
      final repositoryOwner = owner ?? ApiConstants.repositoryOwner;
      final repositoryName = repo ?? ApiConstants.repositoryName;
      
      if (repositoryOwner.isEmpty || repositoryName.isEmpty) {
        _state = GitHubState.error;
        _errorMessage = 'Repository details are not configured properly';
        notifyListeners();
        return;
      }
      
      if (kDebugMode) {
        print('Fetching PRs for: $repositoryOwner/$repositoryName');
      }
      
      _pullRequests = await _getPullRequests(repositoryOwner, repositoryName);
      _state = GitHubState.loaded;
      
      if (kDebugMode) {
        print('Fetched ${_pullRequests.length} pull requests');
      }
      
    } catch (e) {
      _state = GitHubState.error;
      
      if (e is Failure) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      }
      
      if (kDebugMode) {
        print('GitHub Provider Error: $_errorMessage');
        print('Error Type: ${e.runtimeType}');
        print('Full Error: $e');
      }
    }
    notifyListeners();
  }
  
  Future<void> refresh() async {
    await fetchPullRequests();
  }
  
  void clearError() {
    _errorMessage = null;
    if (_state == GitHubState.error) {
      _state = _pullRequests.isEmpty ? GitHubState.initial : GitHubState.loaded;
    }
    notifyListeners();
  }
}
