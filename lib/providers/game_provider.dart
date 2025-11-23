import 'dart:math';
import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/word_pair.dart';
import '../utils/game_data.dart';

enum GamePhase { setup, roleReveal, discussion, voting, roundResult, gameOver }

enum WinnerTeam { none, undercovers, citizens }

class GameProvider with ChangeNotifier {
  List<Player> _players = [];
  int _currentPlayerIndex = 0;
  GamePhase _currentPhase = GamePhase.setup;
  String _winnerMessage = '';
  WordPair? _currentWordPair;
  Player? _lastEliminatedPlayer;
  WinnerTeam _winningTeam = WinnerTeam.none;

  List<Player> get players => _players;
  List<Player> get activePlayers =>
      _players.where((p) => !p.isEliminated).toList();
  int get currentPlayerIndex => _currentPlayerIndex;
  Player get currentPlayer => _players[_currentPlayerIndex];
  GamePhase get currentPhase => _currentPhase;
  String get winnerMessage => _winnerMessage;
  Player? get lastEliminatedPlayer => _lastEliminatedPlayer;
  WinnerTeam get winningTeam => _winningTeam;

  void setGameSettings(int totalPlayers, int undercoverCount) {
    _players = List.generate(totalPlayers, (index) {
      return Player(id: index.toString(), name: 'Player ${index + 1}');
    });
    _startGame(undercoverCount);
  }

  void updatePlayerName(String id, String name) {
    final player = _players.firstWhere((p) => p.id == id);
    player.name = name;
    notifyListeners();
  }

  void _startGame(int undercoverCount) {
    _winnerMessage = '';
    _winningTeam = WinnerTeam.none;

    // reset game state
    for (var p in _players) {
      p.isEliminated = false;
      p.isRevealed = false;
      p.votes = 0;
      p.isUndercover = false;
    }

    // assign roles
    final random = Random();
    var indices = List.generate(_players.length, (i) => i);
    indices.shuffle(random);

    for (int i = 0; i < undercoverCount; i++) {
      _players[indices[i]].isUndercover = true;
    }

    // assign words
    _currentWordPair =
        GameData.wordPairs[random.nextInt(GameData.wordPairs.length)];
    for (var p in _players) {
      p.word = p.isUndercover
          ? _currentWordPair!.undercoverWord
          : _currentWordPair!.citizenWord;
    }

    _currentPlayerIndex = 0;
    _currentPhase = GamePhase.roleReveal;
    notifyListeners();
  }

  void nextPlayerRoleReveal() {
    if (_currentPlayerIndex < _players.length - 1) {
      _currentPlayerIndex++;
    } else {
      _currentPhase = GamePhase.discussion;
    }
    notifyListeners();
  }

  void startVoting() {
    _currentPlayerIndex = 0;
    // only active players vote
    while (_currentPlayerIndex < _players.length &&
        _players[_currentPlayerIndex].isEliminated) {
      _currentPlayerIndex++;
    }
    _currentPhase = GamePhase.voting;
    notifyListeners();
  }

  void castVote(String targetPlayerId) {
    final target = _players.firstWhere((p) => p.id == targetPlayerId);
    target.votes++;

    // move to next active voter
    do {
      _currentPlayerIndex++;
    } while (_currentPlayerIndex < _players.length &&
        _players[_currentPlayerIndex].isEliminated);

    if (_currentPlayerIndex >= _players.length) {
      _calculateRoundResult();
    } else {
      notifyListeners();
    }
  }

  void _calculateRoundResult() {
    // find player with max votes
    int maxVotes = 0;
    for (var p in activePlayers) {
      if (p.votes > maxVotes) maxVotes = p.votes;
    }

    List<Player> maxVoters = activePlayers
        .where((p) => p.votes == maxVotes)
        .toList();

    if (maxVoters.length == 1) {
      // someone eliminated
      maxVoters.first.isEliminated = true;
      _lastEliminatedPlayer = maxVoters.first;
      _checkWinCondition(eliminatedPlayer: maxVoters.first);
    } else {
      // tie
      _lastEliminatedPlayer = null;
      _winningTeam = WinnerTeam.none;
      _currentPhase = GamePhase.roundResult;
      _winnerMessage = "It's a tie! No one was eliminated.";
      notifyListeners();
    }

    // reset votes for next round
    for (var p in _players) p.votes = 0;
  }

  // check win cond
  void _checkWinCondition({Player? eliminatedPlayer}) {
    int activeUndercovers = activePlayers.where((p) => p.isUndercover).length;
    int activeCivilians = activePlayers.where((p) => !p.isUndercover).length;

    if (activeUndercovers == 0) {
      _winningTeam = WinnerTeam.citizens;
      _winnerMessage = "Citizens Win! All Undercovers eliminated.";
      _currentPhase = GamePhase.gameOver;
    } else if (activeUndercovers >= activeCivilians) {
      _winningTeam = WinnerTeam.undercovers;
      _winnerMessage = "Undercovers Win! They have equal or majority numbers.";
      _currentPhase = GamePhase.gameOver;
    } else {
      _winningTeam = WinnerTeam.none;
      _winnerMessage = "${eliminatedPlayer?.name} was eliminated.";
      _currentPhase = GamePhase.roundResult;
    }
    notifyListeners();
  }

  void nextRound() {
    if (_currentPhase == GamePhase.gameOver) {
      _currentPhase = GamePhase.setup;
    } else {
      _currentPhase = GamePhase.discussion;
    }
    notifyListeners();
  }

  void restartGame() {
    _currentPhase = GamePhase.setup;
    _players = [];
    notifyListeners();
  }
}
