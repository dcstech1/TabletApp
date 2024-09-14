import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabletapp/presentation/screens/home/home.dart';
import 'package:tabletapp/presentation/screens/login/login.dart';
import 'package:tabletapp/routes/route_generator.dart';

import 'core/theme/app_theme.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLoginStatus(), // Check login status asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while checking login status
          return CircularProgressIndicator();
        } else {
          // Determine which screen to show based on login status
          final bool isLoggedIn = snapshot.data ?? false;
          return MaterialApp(
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
            debugShowCheckedModeBanner: false,
            home: isLoggedIn ? login() : login(),
            theme: AppTheme.appThemeData,
          );
        }
      },
    );
  }


  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
