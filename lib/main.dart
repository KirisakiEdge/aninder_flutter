import 'package:aninder/Routes.dart';
import 'package:aninder/feature/data/datasources/auth_local_data_source.dart';
import 'package:aninder/feature/ui/screens/FeedScreen.dart';
import 'package:aninder/feature/ui/screens/LoginScreen.dart';
import 'package:aninder/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'feature/ui/screens/HomeScreen.dart';

void main() async {
  await initGetIn();
  runApp(const MyApp());
}

// GoRouter configuration
final _router = GoRouter(
    initialLocation: Routes.LOGIN.name,
    routes: [
      GoRoute(
        path: Routes.LOGIN.name,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: Routes.HOME.name,
        builder: (context, state) {
          final code = state.uri.queryParameters['code'];
          return HomeScreen(authCode: code);
        },
      ),
      GoRoute(
        path: Routes.FEED.name,
        builder: (context, state) {
          final extra = state.extra as Map<String, Object>;
          final selectedGenres = extra["selectedGenres"] as List<String>;
          final selectedTags = extra["selectedTags"] as List<String>;
          final currentYear = extra["currentYear"] as int;
          return FeedScreen(
              selectedGenres: selectedGenres,
              selectedTags: selectedTags,
              currentYear: currentYear);
        },
      ),
    ],
    redirect: (context, state) async {
      final dataStorage = GetIt.instance<AuthLocalDataSource>();
      final token = await dataStorage.getToken();
      final uri = state.uri;
      if (uri.scheme == 'aninder' && uri.host == 'callback') {
        final code = uri.queryParameters['code'];
        return "${Routes.HOME.name}?code=$code";
      } else if (token != null && uri.path == Routes.LOGIN.name) {
        return Routes.HOME.name;
      }
      return null;
    });

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                    const TextStyle(color: Colors.grey)))),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      routerConfig: _router,
    );
  }
}
