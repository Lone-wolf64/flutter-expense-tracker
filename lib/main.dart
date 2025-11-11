import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tracker_app/presentation/screen/add_expense.dart';

import 'package:tracker_app/presentation/screen/homescreen.dart' hide HomeScreen;
import 'package:tracker_app/presentation/screen/logo_page.dart';
import 'package:tracker_app/presentation/screen/profile.dart';
import 'package:tracker_app/presentation/screen/transactions.dart';
import 'presentation/screen/sign_up.dart';
import 'package:flutter/material.dart';
import 'presentation/screen/login.dart';
import 'presentation/screen/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.setLanguageCode('en');

  print('✅ Firebase initialized successfully!');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() => _isDarkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: LogoPage(), // 👈 You can pass theme toggle here too if needed
      routes: {
        '/logo' : (context) => const LogoPage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUp(),
        '/home': (context) =>  HomeScreen(),
        '/add-expense': (context) => const AddExpensePage(),
        '/transactions': (context) => const TransactionPage(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

