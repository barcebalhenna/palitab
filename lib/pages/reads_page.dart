import 'package:flutter/material.dart';
import '../theme.dart';

class ReadsPage extends StatelessWidget {
  final List<Map<String, dynamic>> unlocked = [
    {
      'title': 'Alamat ng Pinya',
      'level': 1,
      'image': 'assets/images/ggi_alamatngpinya.png',
    },
    {
      'title': 'The Monkey and the Turtle',
      'level': 2,
      'image': 'assets/images/ggi_monkey-turtle.png',
    },
    {
      'title': 'Maria Makiling',
      'level': 3,
      'image': 'assets/images/ggi_mariamakiling.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFDE7), Color(0xFFB3E5FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '📚 Your Unlocked Stories',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              shadows: [
                Shadow(
                  color: Colors.white,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Colorful story cards
          ...unlocked.map((s) {
            final String title = s['title'] as String;
            final int level = s['level'] as int;
            final String image = s['image'] as String;

            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/alamat'),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Gradient overlay for readability
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),

                    // Title + info
                    Positioned(
                      left: 16,
                      bottom: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 3,
                                  )
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Lvl $level",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
