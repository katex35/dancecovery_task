import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/setup_screen.dart';
import 'screens/role_reveal_screen.dart';
import 'screens/discussion_screen.dart';
import 'screens/voting_screen.dart';
import 'screens/round_result_screen.dart';
import 'screens/game_over_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: 'Undercover Game',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const GameNavigator(),
      ),
    );
  }
}

class GameNavigator extends StatelessWidget {
  const GameNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final gamePhase = context.select((GameProvider p) => p.currentPhase);

    switch (gamePhase) {
      case GamePhase.setup:
        return const SetupScreen();
      case GamePhase.roleReveal:
        return const RoleRevealScreen();
      case GamePhase.discussion:
        return const DiscussionScreen();
      case GamePhase.voting:
        return const VotingScreen();
      case GamePhase.roundResult:
        return const RoundResultScreen();
      case GamePhase.gameOver:
        return const GameOverScreen();
    }
  }
}
