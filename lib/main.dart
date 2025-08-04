import 'package:flutter/material.dart';
import 'package:github_pr_viewer_app/domain/usecases/get_pull_request.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'core/network/api_client.dart';
import 'data/datasources/auth_local_datasource.dart';
import 'data/datasources/github_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/github_repository_impl.dart';
import 'domain/usecases/login_user.dart';
import 'domain/usecases/logout_user.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/github_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/pull_request_list_screen.dart';
import 'presentation/screens/pull_request_detail_screen.dart';
import 'presentation/theme/app_theme.dart';
import 'domain/entities/pull_request.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthLocalDataSource>(
          create: (_) =>
              AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences),
        ),
        Provider<GitHubRemoteDataSource>(
          create: (_) => GitHubRemoteDataSourceImpl(
            apiClient: ApiClient(client: http.Client()),
          ),
        ),

        ProxyProvider<AuthLocalDataSource, AuthRepositoryImpl>(
          update: (_, authLocalDataSource, __) =>
              AuthRepositoryImpl(localDataSource: authLocalDataSource),
        ),
        ProxyProvider<GitHubRemoteDataSource, GitHubRepositoryImpl>(
          update: (_, githubRemoteDataSource, __) =>
              GitHubRepositoryImpl(remoteDataSource: githubRemoteDataSource),
        ),

        ProxyProvider<AuthRepositoryImpl, LoginUser>(
          update: (_, authRepository, __) => LoginUser(authRepository),
        ),
        ProxyProvider<AuthRepositoryImpl, LogoutUser>(
          update: (_, authRepository, __) => LogoutUser(authRepository),
        ),
        ProxyProvider<GitHubRepositoryImpl, GetPullRequests>(
          update: (_, githubRepository, __) =>
              GetPullRequests(githubRepository),
        ),

        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(sharedPreferences),
        ),
        ChangeNotifierProxyProvider3<
          LoginUser,
          LogoutUser,
          AuthRepositoryImpl,
          AuthProvider
        >(
          create: (context) => AuthProvider(
            loginUser: context.read<LoginUser>(),
            logoutUser: context.read<LogoutUser>(),
            authRepository: context.read<AuthRepositoryImpl>(),
          ),
          update: (_, loginUser, logoutUser, authRepository, previous) =>
              previous ??
              AuthProvider(
                loginUser: loginUser,
                logoutUser: logoutUser,
                authRepository: authRepository,
              ),
        ),
        ChangeNotifierProxyProvider<GetPullRequests, GitHubProvider>(
          create: (context) =>
              GitHubProvider(getPullRequests: context.read<GetPullRequests>()),
          update: (_, getPullRequests, previous) =>
              previous ?? GitHubProvider(getPullRequests: getPullRequests),
        ),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, authProvider, child) {
          return MaterialApp(
            title: 'GitHub PR Viewer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: _getInitialScreen(authProvider),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/login':
                  return MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  );
                case '/pull-requests':
                  return MaterialPageRoute(
                    builder: (context) => const PullRequestListScreen(),
                  );
                case '/pull-request-detail':
                  final pullRequest = settings.arguments as PullRequest;
                  return MaterialPageRoute(
                    builder: (context) =>
                        PullRequestDetailScreen(pullRequest: pullRequest),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  );
              }
            },
          );
        },
      ),
    );
  }

  Widget _getInitialScreen(AuthProvider authProvider) {
    switch (authProvider.state) {
      case AuthState.authenticated:
        return const PullRequestListScreen();
      case AuthState.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthState.unauthenticated:
      case AuthState.initial:
        return const LoginScreen();
    }
  }
}
