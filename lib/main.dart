import 'package:flutter/material.dart';
import 'package:pokeapp/screens/bottom_nav_screen.dart';
import 'package:pokeapp/screens/dashboard_screen.dart';
import 'package:pokeapp/screens/login_screen.dart';
import 'package:pokeapp/screens/profile_screen.dart';
import 'package:pokeapp/screens/register_screen.dart';
import 'package:pokeapp/screens/settings_screen.dart';
import 'package:pokeapp/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      routes: {
        'welcome': (context) => const WelcomeScreen(),
        'register': (context) => const RegisterScreen(),
        'login': (context) => const LoginScreen(),
        'dashboard': (context) => const DashboardScreen(),
        'profile': (context) => const ProfileScreen(),
        'settings': (context) => const SettingsScreen(),
        'nav': (context) => const BottomNavBarScreen(),
      },
    );
  }
}