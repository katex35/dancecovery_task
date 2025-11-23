import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/player.dart';
import '../widgets/game_layout.dart';
import '../widgets/player_grid_item.dart';

class RoleRevealScreen extends StatelessWidget {
  const RoleRevealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final players = gameProvider.players;
    final currentPlayerIndex = gameProvider.currentPlayerIndex;

    return GameLayout(
      title: 'Player ${currentPlayerIndex + 1}',
      subtitle: 'Reveal your card. It\'s your turn!',
      child: Column(
        children: [
          // instruction card
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
          //   child: Column(
          //     children: [
          //       Text(
          //         'Player ${currentPlayerIndex + 1}',
          //         style: const TextStyle(
          //           color: Colors.white,
          //           fontSize: 32,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       const Text(
          //         'It\'s your turn!',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 32,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       Text(
          //         'Hide the phone, so only you can see!',
          //         style: TextStyle(
          //           color: Colors.white.withOpacity(0.7),
          //           fontSize: 18,
          //         ),
          //         textAlign: TextAlign.center,
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 2),
          // grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 4,
                childAspectRatio: players.length <= 6 ? 0.85 : 1,
              ),
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                final isCurrentTurn = index == currentPlayerIndex;
                final isRevealed = player.isRevealed;

                return PlayerGridItem(
                  name: player.name,
                  isUnknown: !isRevealed,
                  isSelf: isCurrentTurn,
                  onTap: isCurrentTurn && !isRevealed
                      ? () => _showNameInputDialog(context, player)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showNameInputDialog(BuildContext context, Player player) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero, // match role dialog sizing behavior
          child: Container(
            width: 350,
            height: 260,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // title
                const Positioned(
                  top: 24,
                  left: 0,
                  right: 0,
                  child: Text(
                    'Enter Your Name',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Geist',
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),

                // text
                Positioned(
                  top: 100,
                  left: 24,
                  right: 24,
                  child: TextField(
                    controller: nameController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Geist',
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: 'Geist',
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9663E3)),
                      ),
                    ),
                    autofocus: true,
                  ),
                ),

                // bttn
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF41236F),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (nameController.text.isNotEmpty) {
                              Navigator.pop(context);
                              _showRoleDialog(
                                context,
                                player,
                                nameController.text,
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: const Center(
                            child: Text(
                              'Reveal Role',
                              style: TextStyle(
                                fontFamily: 'Geist',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRoleDialog(BuildContext context, Player player, String name) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.updatePlayerName(player.id, name);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: 350,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // title: your secret word
                const Positioned(
                  top: 24, // based on layout
                  left: 0,
                  right: 0,
                  child: Text(
                    'Your Secret Word',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Geist',
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),

                // image (ua/civ)
                Positioned(
                  top:
                      63, // 386 (image top) - 323 (group top) = 63px relative to container
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      player.isUndercover
                          ? 'assets/undercover.png'
                          : 'assets/civilian.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // secret word (thunder)
                Positioned(
                  top: 180, // below image
                  left: 0,
                  right: 0,
                  child: Text(
                    player.word.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Geist',
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      color: Color(0xFF20446E),
                      height: 1.0,
                    ),
                  ),
                ),

                // bttn
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF41236F),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            player.isRevealed = true;
                            gameProvider.nextPlayerRoleReveal();
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: const Center(
                            child: Text(
                              'Got it!',
                              style: TextStyle(
                                fontFamily: 'Geist',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
