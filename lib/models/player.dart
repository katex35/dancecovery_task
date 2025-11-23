class Player {
  final String id;
  String name;
  bool isUndercover;
  String word;
  bool isEliminated;
  bool isRevealed;
  int votes;

  Player({
    required this.id,
    required this.name,
    this.isUndercover = false,
    this.word = '',
    this.isEliminated = false,
    this.isRevealed = false,
    this.votes = 0,
  });
}
