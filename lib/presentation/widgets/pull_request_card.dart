import 'package:flutter/material.dart';
import '../../domain/entities/pull_request.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/constants/app_constants.dart';

class PullRequestCard extends StatelessWidget {
  final PullRequest pullRequest;
  final VoidCallback? onTap;
  
  const PullRequestCard({
    super.key,
    required this.pullRequest,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.defaultPadding / 2,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: pullRequest.user.avatarUrl.isNotEmpty
                        ? NetworkImage(pullRequest.user.avatarUrl)
                        : null,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    child: pullRequest.user.avatarUrl.isEmpty
                        ? Icon(
                            Icons.person,
                            color: theme.colorScheme.onSurfaceVariant,
                          )
                        : null,
                    onBackgroundImageError: (exception, stackTrace) {
                      // Handle image loading error silently
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pullRequest.title.isNotEmpty 
                              ? pullRequest.title 
                              : 'No Title',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              pullRequest.user.login.isNotEmpty 
                                  ? pullRequest.user.login 
                                  : 'Unknown User',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStateColor(pullRequest.state, theme),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                pullRequest.number > 0 
                                    ? '#${pullRequest.number}' 
                                    : '#0',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (pullRequest.body.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  pullRequest.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormatter.timeAgo(pullRequest.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getStateColor(String state, ThemeData theme) {
    switch (state.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.red;
      case 'merged':
        return Colors.purple;
      default:
        return theme.colorScheme.primary;
    }
  }
}
