import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_layout.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _totalPlayers = 5;
  int _undercoverCount = 2;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  int get _civilianCount => _totalPlayers - _undercoverCount;

  void _updateUndercoverCount(int delta) {
    setState(() {
      int newUndercoverCount = _undercoverCount + delta;
      int newCivilianCount = _totalPlayers - newUndercoverCount;

      // undercover >= 1
      // civilian >= undercover + 1
      if (newUndercoverCount >= 1 &&
          newCivilianCount >= newUndercoverCount + 1) {
        _undercoverCount = newUndercoverCount;
      }
    });
  }

  void _onTotalPlayersChanged(double value) {
    setState(() {
      _totalPlayers = value.toInt();
      // reset to valid state (if rules are broken by changing total)
      if (_civilianCount < _undercoverCount + 1) {
        while (_civilianCount < _undercoverCount + 1 && _undercoverCount > 1) {
          _undercoverCount--;
        }
      }
      // at least 1 undercover
      if (_undercoverCount < 1) {
        _undercoverCount = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameLayout(
      title: 'Undercover',
      subtitle: 'Choose your player count',
      child: Column(
        children: [
          const SizedBox(height: 20),

          // player count card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Players: $_totalPlayers',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 24,
                    activeTrackColor: const Color(0xFF9663E3),
                    inactiveTrackColor: const Color(0xFFBBA4DE),
                    thumbColor: const Color(0xFF8D57DF),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 16,
                      elevation: 4,
                    ),
                    overlayColor: const Color(
                      0xFF8D57DF,
                    ).withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: _totalPlayers.toDouble(),
                    min: 3,
                    max: 12,
                    divisions: 9,
                    onChanged: _onTotalPlayersChanged,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // roles card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // civs
                Row(
                  children: [
                    Text(
                      '$_civilianCount x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Image.asset('assets/civilian.png', width: 64, height: 64),
                    const SizedBox(width: 16),
                    const Text(
                      'Civilian',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // undercovers
                Row(
                  children: [
                    Text(
                      '$_undercoverCount x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Image.asset('assets/undercover.png', width: 64, height: 64),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Undercover',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    _buildCircleButton(
                      icon: Icons.remove,
                      onPressed: () => _updateUndercoverCount(-1),
                    ),
                    const SizedBox(width: 12),
                    _buildCircleButton(
                      icon: Icons.add,
                      onPressed: () => _updateUndercoverCount(1),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // start button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF41236F),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 65),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Provider.of<GameProvider>(
                    context,
                    listen: false,
                  ).setGameSettings(_totalPlayers, _undercoverCount);
                },
                child: const Text(
                  'Start the Game',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFAB96CC),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: -3,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: -4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        iconSize: 20,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
