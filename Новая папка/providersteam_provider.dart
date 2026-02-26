import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/team.dart';

class TeamProvider with ChangeNotifier {
  Team? _currentTeam;
  List<ScoreTransaction> _transactions = [];
  List<Team> _leaderboard = [];
  bool _isLoading = false;

  Team? get currentTeam => _currentTeam;
  List<ScoreTransaction> get transactions => _transactions;
  List<Team> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadUserTeam() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Найти команду, в которой состоит пользователь
      final teamsSnapshot = await _firestore
          .collection('teams')
          .where('members', arrayContains: user.uid)
          .limit(1)
          .get();

      if (teamsSnapshot.docs.isNotEmpty) {
        _currentTeam = Team.fromFirestore(
          teamsSnapshot.docs.first.data(),
          teamsSnapshot.docs.first.id,
        );
        await _loadTeamTransactions();
      }

      await _loadLeaderboard();
    } catch (error) {
      print('Error loading team: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadTeamTransactions() async {
    if (_currentTeam == null) return;

    final transactionsSnapshot = await _firestore
        .collection('score_transactions')
        .where('teamId', isEqualTo: _currentTeam!.id)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    _transactions = transactionsSnapshot.docs.map((doc) {
      final data = doc.data();
      return ScoreTransaction(
        id: doc.id,
        teamId: data['teamId'],
        teamName: data['teamName'],
        points: data['points'],
        description: data['description'],
        category: data['category'],
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        addedBy: data['addedBy'],
      );
    }).toList();
  }

  Future<void> _loadLeaderboard() async {
    final teamsSnapshot = await _firestore
        .collection('teams')
        .orderBy('score', descending: true)
        .limit(20)
        .get();

    _leaderboard = teamsSnapshot.docs.map((doc) {
      return Team.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  Stream<List<Team>> getLeaderboardStream() {
    return _firestore
        .collection('teams')
        .orderBy('score', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Team.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Stream<List<ScoreTransaction>> getTeamTransactionsStream(String teamId) {
    return _firestore
        .collection('score_transactions')
        .where('teamId', isEqualTo: teamId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return ScoreTransaction(
                id: doc.id,
                teamId: data['teamId'],
                teamName: data['teamName'],
                points: data['points'],
                description: data['description'],
                category: data['category'],
                timestamp: (data['timestamp'] as Timestamp).toDate(),
                addedBy: data['addedBy'],
              );
            }).toList());
  }
}