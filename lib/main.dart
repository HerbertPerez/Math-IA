import 'package:flutter/material.dart';
import 'package:math_ia/core/providers/user_provider.dart';
import 'package:math_ia/features/home/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math-IA',
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
