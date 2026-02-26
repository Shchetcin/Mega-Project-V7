class Team {
  final String id;
  final String name;
  final String color;
  final int score;
  final List<String> members;
  final DateTime createdAt;

  Team({
    required this.id,
    required this.name,
    required this.color,
    required this.score,
    required this.members,
    required this.createdAt,
  });

  factory Team.fromFirestore(Map<String, dynamic> data, String id) {
    return Team(
      id: id,
      name: data['name'] ?? '',
      color: data['color'] ?? '#4285F4',
      score: data['score'] ?? 0,
      members: List<String>.from(data['members'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}

class ScoreTransaction {
  final String id;
  final String teamId;
  final String teamName;
  final int points;
  final String description;
  final String category;
  final DateTime timestamp;
  final String addedBy;

  ScoreTransaction({
    required this.id,
    required this.teamId,
    required this.teamName,
    required this.points,
    required this.description,
    required this.category,
    required this.timestamp,
    required this.addedBy,
  });
}