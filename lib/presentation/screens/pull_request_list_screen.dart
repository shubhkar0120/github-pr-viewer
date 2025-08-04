// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/github_provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/theme_provider.dart';
// import '../widgets/pull_request_card.dart';
// import '../widgets/shimmer_loading.dart';
// import '../widgets/error_widget.dart';
// import 'login_screen.dart';

// class PullRequestListScreen extends StatefulWidget {
//   static const routeName = '/pull-requests';

//   const PullRequestListScreen({Key? key}) : super(key: key);

//   @override
//   State<PullRequestListScreen> createState() => _PullRequestListScreenState();
// }

// class _PullRequestListScreenState extends State<PullRequestListScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _refreshAnimationController;
//   late Animation<double> _refreshAnimation;

//   // Repository configuration - Update these for your repo
//   static const String owner = 'flutter';
//   static const String repo = 'flutter';

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     _loadPullRequests();
//   }

//   void _setupAnimations() {
//     _refreshAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _refreshAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _refreshAnimationController,
//       curve: Curves.easeInOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _refreshAnimationController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadPullRequests() async {
//     final githubProvider = Provider.of<GitHubProvider>(context, listen: false);
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     await githubProvider.fetchPullRequests(
//       owner: owner,
//       repo: repo,
//       token: authProvider.token,
//     );
//   }

//   Future<void> _handleRefresh() async {
//     _refreshAnimationController.forward().then((_) {
//       _refreshAnimationController.reset();
//     });

//     await _loadPullRequests();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(),
//       body: _buildBody(),
//       floatingActionButton: _buildRefreshFab(),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       title: const Text(
//         'Pull Requests',
//         style: TextStyle(fontWeight: FontWeight.w600),
//       ),
//       elevation: 0,
//       actions: [
//         Consumer<AuthProvider>(
//           builder: (context, authProvider, child) {
//             return PopupMenuButton<String>(
//               icon: CircleAvatar(
//                 backgroundColor: Theme.of(context).primaryColor,
//                 child: const Icon(
//                   Icons.person,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//               onSelected: (value) => _handleMenuAction(value),
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   value: 'token',
//                   child: Row(
//                     children: [
//                       const Icon(Icons.key),
//                       const SizedBox(width: 8),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Text('Token'),
//                           Text(
//                             authProvider.token ?? 'No token',
//                             style: Theme.of(context).textTheme.bodySmall,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'theme',
//                   child: Row(
//                     children: [
//                       Icon(Icons.palette),
//                       SizedBox(width: 8),
//                       Text('Toggle Theme'),
//                     ],
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'logout',
//                   child: Row(
//                     children: [
//                       Icon(Icons.logout, color: Colors.red),
//                       SizedBox(width: 8),
//                       Text('Logout', style: TextStyle(color: Colors.red)),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildBody() {
//     return Consumer<GitHubProvider>(
//       builder: (context, githubProvider, child) {
//         switch (githubProvider.state) {
//           case GitHubState.loading:
//             return const ShimmerLoading();
//           case GitHubState.loaded:
//             return _buildSuccessView(githubProvider);
//           case GitHubState.error:
//             return CustomErrorWidget(
//               message: githubProvider.errorMessage ?? 'An error occurred',
//               onRetry: _loadPullRequests,
//             );
//           case GitHubState.idle:
//           default:
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//         }
//       },
//     );
//   }

//   Widget _buildSuccessView(GitHubProvider githubProvider) {
//     if (githubProvider.pullRequests.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.inbox_outlined,
//               size: 64,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No pull requests found',
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     color: Colors.grey[600],
//                   ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Repository: $owner/$repo',
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: Colors.grey[500],
//                   ),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _handleRefresh,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: githubProvider.pullRequests.length,
//         itemBuilder: (context, index) {
//           final pullRequest = githubProvider.pullRequests[index];
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: PullRequestCard(
//               pullRequest: pullRequest,
//               onTap: () => _showPullRequestDetails(pullRequest),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildRefreshFab() {
//     return Consumer<GitHubProvider>(
//       builder: (context, githubProvider, child) {
//         return AnimatedBuilder(
//           animation: _refreshAnimation,
//           builder: (context, child) {
//             return FloatingActionButton(
//               onPressed: githubProvider.state == GitHubState.loading
//                   ? null
//                   : _handleRefresh,
//               child: Transform.rotate(
//                 angle: _refreshAnimation.value * 2 * 3.14159,
//                 child: const Icon(Icons.refresh),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _handleMenuAction(String action) {
//     switch (action) {
//       case 'token':
//         _showTokenDialog();
//         break;
//       case 'theme':
//         Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
//         break;
//       case 'logout':
//         _handleLogout();
//         break;
//     }
//   }

//   void _showTokenDialog() {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Stored Token'),
//         content: SelectableText(
//           authProvider.token ?? 'No token stored',
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 fontFamily: 'monospace',
//               ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showPullRequestDetails(pullRequest) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.7,
//         minChildSize: 0.3,
//         maxChildSize: 0.95,
//         builder: (context, scrollController) {
//           return Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).cardColor,
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     controller: scrollController,
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           pullRequest.title,
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleLarge
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 16,
//                               backgroundImage: NetworkImage(
//                                 pullRequest.user.avatarUrl,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Text(pullRequest.user.login),
//                             const Spacer(),
//                             Text(
//                               '#${pullRequest.number}',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodySmall
//                                   ?.copyWith(
//                                     color: Colors.grey[600],
//                                   ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         const Divider(),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Description',
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium
//                               ?.copyWith(
//                                 fontWeight: FontWeight.w600,
//                               ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           pullRequest.body.isEmpty
//                               ? 'No description provided'
//                               : pullRequest.body,
//                           style: Theme.of(context).textTheme.bodyMedium,
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _handleLogout() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await Provider.of<AuthProvider>(context, listen: false).logout();
//       if (mounted) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//       }
//     }
//   }
// }

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
