import 'package:flutter/material.dart';
import 'theme.dart';
import 'pages/onboarding_page.dart';
import 'pages/login_signup_page.dart';
import 'pages/teacher_dashboard_page.dart';
import 'pages/child_home_wrapper.dart';
import 'pages/alamat_story_page.dart';
import 'pages/teacher_login_page.dart';
import 'pages/child_login_page.dart';

void main() {
  runApp(PalitabApp());
}

class PalitabApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palitab',
      theme: PalitabTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => OnboardingPage(),
        '/login': (_) => LoginSignupPage(),
        '/teacher-login': (_) => TeacherLoginPage(),
        '/child-login': (_) => ChildLoginPage(),
        '/teacher': (_) => TeacherDashboardPage(),
        '/child': (_) => ChildHomeWrapper(),
        '/alamat': (_) => AlamatStoryPage(),
      },
    );
  }
}
