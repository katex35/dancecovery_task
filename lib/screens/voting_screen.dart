import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_layout.dart';
import '../widgets/player_grid_item.dart';
import '../widgets/glass_button.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  bool _isReadyToVote = false;
  String? _selectedPlayerId;

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final currentPlayer = gameProvider.currentPlayer;
    final allPlayers = gameProvider.players;

    if (!_isReadyToVote) {
      return GameLayout(
        title: 'Elimination Time',
        subtitle: 'Pass the phone to...',
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentPlayer.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GlassButton(
                  text: 'I am Ready',
                  onPressed: () {
                    setState(() {
                      _isReadyToVote = true;
                      _selectedPlayerId = null;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GameLayout(
      title: '${currentPlayer.name}!',
      subtitle: 'Vote to eliminate someone.',
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
                final isSelf = player.id == currentPlayer.id;
                final isEliminated = player.isEliminated;
                final isSelected = _selectedPlayerId == player.id;

                return Opacity(
                  opacity: isEliminated ? 0.5 : 1.0,
                  child: PlayerGridItem(
                    name: player.name,
                    isUnknown: false,
                    isSelected: isSelected,
                    isSelf: isSelf,
                    onTap: (!isSelf && !isEliminated)
                        ? () {
                            setState(() {
                              _selectedPlayerId = player.id;
                            });
                          }
                        : null,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: GlassButton(
              text: 'Go to Next Vote!',
              onPressed: () {
                if (_selectedPlayerId != null) {
                  gameProvider.castVote(_selectedPlayerId!);
                  if (gameProvider.currentPhase != GamePhase.roundResult) {
                    setState(() {
                      _isReadyToVote = false;
                      _selectedPlayerId = null;
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a player to eliminate'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
