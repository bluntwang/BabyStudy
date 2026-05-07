import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/game_list_screen.dart';
import '../screens/game_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String gameList = '/game-list';
  static const String game = '/game';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case gameList:
        final ageGroup = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => GameListScreen(ageGroup: ageGroup),
        );
      case game:
        final gameParams = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => GameScreen(
            gameType: gameParams['gameType'],
            ageGroup: gameParams['ageGroup'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
