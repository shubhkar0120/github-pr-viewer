import 'package:flutter/material.dart';
import '../../domain/entities/pull_request.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class PullRequestDetailScreen extends StatelessWidget {
  final PullRequest pullRequest;
  
  const PullRequestDetailScreen({
    super.key,
    required this.pullRequest,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'PR #${pullRequest.number}',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      pullRequest.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Author Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(pullRequest.user.avatarUrl),
                          backgroundColor: theme.colorScheme.surfaceVariant,
                          child: pullRequest.user.avatarUrl.isEmpty
                              ? Icon(
                                  Icons.person,
                                  color: theme.colorScheme.onSurfaceVariant,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pullRequest.user.login,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'opened this pull request',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStateColor(pullRequest.state),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            pullRequest.state.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Metadata Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      'PR Number',
                      '#${pullRequest.number}',
                      Icons.tag,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      'Created',
                      pullRequest.createdAt != null
                          ? DateFormatter.formatDateTime(pullRequest.createdAt!)
                          : 'Unknown',
                      Icons.access_time,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      'Updated',
                      pullRequest.updatedAt != null
                          ? DateFormatter.formatDateTime(pullRequest.updatedAt!)
                          : 'Unknown',
                      Icons.update,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      'State',
                      pullRequest.state.toUpperCase(),
                      Icons.info_outline,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Description Card
            if (pullRequest.body.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          pullRequest.body,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'No description provided',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // In a real app, you might open the PR in a web view or browser
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Would open: ${pullRequest.htmlUrl}'),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_browser),
                label: const Text('View on GitHub'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Color _getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.red;
      case 'merged':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}
