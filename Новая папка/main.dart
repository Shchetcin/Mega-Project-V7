import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/team_dashboard.dart';
import 'providers/auth_provider.dart';
import 'providers/team_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
      ],
      child: MaterialApp(
        title: 'Квест Абитуриент',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (authProvider.status == AuthStatus.authenticated) {
      return TeamDashboard();
    } else if (authProvider.status == AuthStatus.unauthenticated) {
      return LoginScreen();
    } else {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}