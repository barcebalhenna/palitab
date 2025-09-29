import 'package:flutter/material.dart';
import '../theme.dart';

class LoginSignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [PalitabTheme.accentWarm, PalitabTheme.accentHot],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // App logo or title
                const Icon(Icons.menu_book_rounded,
                    size: 80, color: PalitabTheme.pureWhite),
                const SizedBox(height: 20),
                const Text(
                  'Get Started with Palitab',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: PalitabTheme.pureWhite,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Choose your role to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 50),

                // Parent/Teacher Card
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/teacher-login'),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: PalitabTheme.pureWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: PalitabTheme.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.school,
                              color: PalitabTheme.purple, size: 32),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Parent / Teacher',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              SizedBox(height: 4),
                              Text('Monitor student progress securely',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: PalitabTheme.accentHot)
                      ],
                    ),
                  ),
                ),

                // Child/Student Card
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/child-login'),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: PalitabTheme.pureWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: PalitabTheme.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.child_care,
                              color: PalitabTheme.teal, size: 32),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Child / Student',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              SizedBox(height: 4),
                              Text('Read stories, play quizzes, and earn XP',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: PalitabTheme.accentHot)
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Back to onboarding
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/'),
                  child: const Text(
                    'Back to Onboarding',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
