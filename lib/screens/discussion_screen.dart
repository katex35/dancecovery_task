import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_layout.dart';
import '../widgets/player_grid_item.dart';
import '../widgets/glass_button.dart';

class DiscussionScreen extends StatelessWidget {
  const DiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final players = gameProvider.activePlayers;

    return GameLayout(
      title: 'Discuss Time!',
      subtitle: 'Describe your secret word.\nUsing just a word or phrase.',
      child: Column(
        children: [
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
                return PlayerGridItem(name: player.name, isUnknown: false);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: GlassButton(
              text: 'Go to Vote!',
              onPressed: () {
                gameProvider.startVoting();
              },
            ),
          ),
        ],
      ),
    );
  }
}
