import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pc = PageController();
  int _page = 0;

  final List<Map<String, String>> slides = [
    {
      'title': 'Welcome to Palitab!',
      'body': 'Discover bilingual stories that make reading fun, engaging, and meaningful — transforming lives through reading.',
      'image': 'assets/images/onboard_reading.png',
    },
    {
      'title': 'Unlock Stories & Quizzes',
      'body': 'Earn stars and XP as you read, play, and learn — unlock more adventures!',
      'image': 'assets/images/onboard_quiz.png',
    },
    {
      'title': 'For Parents & Teachers',
      'body': 'Track progress with secure dashboards and listening tools that support every child’s growth.',
      'image': 'assets/images/onboard_teacher.png',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF6E5), Color(0xFFFFC371)], // soft warm gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pc,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    final s = slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              s['image']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            s['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                              fontFamily: 'ComicNeue', // playful but readable
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            s['body']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  slides.length,
                      (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
                    width: _page == i ? 28 : 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _page == i
                          ? Colors.deepOrange
                          : Colors.deepOrange.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              // Buttons (Next / Get Started + Log In on last page)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: _page == slides.length - 1
                            ? Colors.orange
                            : PalitabTheme.accentWarm,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (_page == slides.length - 1) {
                          Navigator.pushReplacementNamed(context, '/login');
                        } else {
                          _pc.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _page == slides.length - 1 ? 'Get Started' : 'Next',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    if (_page == slides.length - 1) ...[
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          foregroundColor: Colors.deepOrange,
                          side: const BorderSide(color: Colors.deepOrange, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text(
                          'Log In',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
