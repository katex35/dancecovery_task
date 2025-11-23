import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_layout.dart';
import '../widgets/player_grid_item.dart';

class RoundResultScreen extends StatelessWidget {
  const RoundResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final eliminatedPlayer = gameProvider.lastEliminatedPlayer;
    final isTie = eliminatedPlayer == null;
    final allPlayers = gameProvider.players;

    return Scaffold(
      body: Stack(
        children: [
          // background: mimic votingScreen
          GameLayout(
            title: 'Elimination Time',
            subtitle: 'Voting Results',
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: allPlayers.length,
                    itemBuilder: (context, index) {
                      final player = allPlayers[index];
                      final isEliminated = player.isEliminated;

                      return Opacity(
                        opacity: isEliminated ? 0.5 : 1.0,
                        child: PlayerGridItem(
                          name: player.name,
                          isUnknown: false,
                          isSelected: false,
                        ),
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
              child: Container(color: Colors.black.withValues(alpha: 0.2)),
            ),
          ),

          // elimination widget (centered)
          Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isTie) ...[
                    const Text(
                      "It's a tie!",
                      style: TextStyle(
                        fontFamily: 'Geist',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF41236F),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No one was eliminated.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Geist',
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ] else ...[
                    Text(
                      "${eliminatedPlayer.name} was a...",
                      style: const TextStyle(
                        fontFamily: 'Geist',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Image.asset(
                      eliminatedPlayer.isUndercover
                          ? 'assets/undercover.png'
                          : 'assets/civilian.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      eliminatedPlayer.isUndercover ? 'UNDERCOVER' : 'CIVILIAN',
                      style: TextStyle(
                        fontFamily: 'Geist',
                        fontSize: eliminatedPlayer.isUndercover ? 24 : 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF41236F),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF41236F),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      gameProvider.nextRound();
                    },
                    child: Text(
                      isTie
                          ? "Continue"
                          : (eliminatedPlayer.isUndercover
                                ? "GOTCHA!"
                                : "Oh no..."),
                      style: TextStyle(
                        fontFamily: 'Geist',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
