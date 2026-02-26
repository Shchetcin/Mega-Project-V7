import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/team_provider.dart';

class TeamDashboard extends StatefulWidget {
  @override
  _TeamDashboardState createState() => _TeamDashboardState();
}

class _TeamDashboardState extends State<TeamDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    TeamScoreScreen(),
    LeaderboardScreen(),
    TransactionsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Квест Абитуриент'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Команда',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Рейтинг',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'История',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class TeamScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    final team = teamProvider.currentTeam;

    if (team == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple],
            ),
          ),
          child: Column(
            children: [
              Text(
                team.name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '${team.score}',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'баллов',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Состав команды:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: team.members.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text((index + 1).toString()),
                        ),
                        title: Text('Участник ${index + 1}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Team>>(
      stream: Provider.of<TeamProvider>(context).getLeaderboardStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Нет данных'));
        }

        final teams = snapshot.data!;
        final currentTeam = Provider.of<TeamProvider>(context).currentTeam;

        return ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            final isCurrentTeam = currentTeam?.id == team.id;

            return Card(
              color: isCurrentTeam ? Colors.blue[50] : null,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _parseColor(team.color),
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  team.name,
                  style: TextStyle(
                    fontWeight: isCurrentTeam ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: Text(
                  '${team.score}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }
}

class TransactionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    final team = teamProvider.currentTeam;

    if (team == null) {
      return Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<List<ScoreTransaction>>(
      stream: teamProvider.getTeamTransactionsStream(team.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Пока нет начислений',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final transactions = snapshot.data!;

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final isPositive = transaction.points > 0;

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPositive ? Colors.green[100] : Colors.red[100],
                  ),
                  child: Center(
                    child: Text(
                      isPositive ? '+' : '-',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  transaction.description,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${DateFormat('HH:mm').format(transaction.timestamp)} • ${transaction.category}',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  '${isPositive ? '+' : ''}${transaction.points}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}