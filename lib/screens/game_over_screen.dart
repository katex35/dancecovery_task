import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_layout.dart';
import '../widgets/player_grid_item.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final allPlayers = gameProvider.players;

    final isUndercoverWin = gameProvider.winningTeam == WinnerTeam.undercovers;
    final winningTeamName = isUndercoverWin ? 'Undercovers' : 'Citizens';
    final winnerImage = isUndercoverWin
        ? 'assets/undercover.png'
        : 'assets/civilian.png';

    final winningPlayers = allPlayers
        .where((p) => p.isUndercover == isUndercoverWin)
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          // bakground grid of players
          GameLayout(
            title: 'Game Over',
            subtitle: 'Final Results',
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 4,
                      childAspectRatio: allPlayers.length <= 6 ? 0.85 : 1,
                    ),
                    itemCount: allPlayers.length,
                    itemBuilder: (context, index) {
                      final player = allPlayers[index];

                      return PlayerGridItem(
                        name: player.name,
                        isUnknown: false,
                        isSelected: player.isUndercover,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // blur effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withValues(alpha: 0.4)),
            ),
          ),

          // game over card
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // winner team image
                  Image.asset(winnerImage, width: 100, height: 100),
                  const SizedBox(height: 16),

                  // title
                  Text(
                    '$winningTeamName Win!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Geist',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF41236F),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    gameProvider.winnerMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Geist',
                      fontSize: 14,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // players from winner team List
                  const Text(
                    'WINNERS',
                    style: TextStyle(
                      fontFamily: 'Geist',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF41236F),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: winningPlayers.map((player) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isUndercoverWin
                                  ? const Color(0xFF41236F)
                                  : const Color(0xFF00C853),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                player.name.isNotEmpty
                                    ? player.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontFamily: 'Geist',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            player.name,
                            style: const TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // play again button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF41236F),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      gameProvider.restartGame();
                    },
                    child: const Text(
                      'Play Again',
                      style: TextStyle(
                        fontFamily: 'Geist',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
