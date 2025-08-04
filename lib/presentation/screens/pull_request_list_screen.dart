import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/github_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/pull_request_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/error_widget.dart';
import '../../core/constants/app_constants.dart';

class PullRequestListScreen extends StatefulWidget {
  const PullRequestListScreen({super.key});
  
  @override
  State<PullRequestListScreen> createState() => _PullRequestListScreenState();
}

class _PullRequestListScreenState extends State<PullRequestListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final githubProvider = Provider.of<GitHubProvider>(context, listen: false);
      githubProvider.fetchPullRequests();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppConstants.appName,
        showLogout: true,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.token != null) {
                return IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => _showTokenDialog(context, authProvider.token!),
                  tooltip: 'Show Token',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<GitHubProvider>(
        builder: (context, githubProvider, child) {
          if (githubProvider.isLoading) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const ShimmerPullRequestCard(),
            );
          }
          
          if (githubProvider.hasError) {
            return CustomErrorWidget(
              message: githubProvider.errorMessage ?? 'Failed to load pull requests',
              onRetry: () => githubProvider.fetchPullRequests(),
              icon: Icons.code_off,
            );
          }
          
          if (githubProvider.pullRequests.isEmpty) {
            return const CustomErrorWidget(
              message: 'No pull requests found',
              icon: Icons.inbox,
            );
          }
          
          return RefreshIndicator(
            onRefresh: () => githubProvider.refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.defaultPadding / 2,
              ),
              itemCount: githubProvider.pullRequests.length,
              itemBuilder: (context, index) {
                final pullRequest = githubProvider.pullRequests[index];
                return PullRequestCard(
                  pullRequest: pullRequest,
                  onTap: () => _navigateToDetail(pullRequest),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Consumer<GitHubProvider>(
        builder: (context, githubProvider, child) {
          return FloatingActionButton(
            onPressed: () => githubProvider.refresh(),
            tooltip: 'Refresh',
            child: const Icon(Icons.refresh),
          );
        },
      ),
    );
  }
  
  void _navigateToDetail(pullRequest) {
    Navigator.pushNamed(
      context,
      '/pull-request-detail',
      arguments: pullRequest,
    );
  }
  
  void _showTokenDialog(BuildContext context, String token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stored Token'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Current stored token:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                token,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
