import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// 🎨 Modern Role Selection Page
/// First screen after onboarding - choose user type
class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenW = media.size.width;
    final isSmall = screenW < 360;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              PalitabTheme.accentWarm,
              PalitabTheme.accentHot,
              PalitabTheme.purple.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: media.size.height - media.padding.top - media.padding.bottom),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 28),

                    // Floating logo/mascot
                    AnimatedBuilder(
                      animation: _floatAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: Container(
                            width: isSmall ? 92 : 120,
                            height: isSmall ? 92 : 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.18),
                                  blurRadius: 18,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.menu_book_rounded,
                                size: 56,
                                color: PalitabTheme.accentHot,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // App title
                    Text(
                      'Palitab',
                      style: GoogleFonts.fredoka(
                        fontSize: isSmall ? 36 : 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.18),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Transforming Lives Through Reading',
                      style: GoogleFonts.fredoka(
                        fontSize: isSmall ? 14 : 18,
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Text(
                        'Who\'s Here Today?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: isSmall ? 26 : 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Role cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildRoleCard(
                            emoji: '👨‍👩‍👧‍👦',
                            title: 'Parent / Teacher',
                            subtitle: 'Track progress and manage accounts',
                            gradient: const LinearGradient(
                              colors: [
                                PalitabTheme.purple,
                                PalitabTheme.accentHot,
                              ],
                            ),
                            onTap: () => Navigator.pushNamed(context, '/teacher-login'),
                            compact: isSmall,
                          ),
                          const SizedBox(height: 14),
                          _buildRoleCard(
                            emoji: '🎒',
                            title: 'Student',
                            subtitle: 'Read stories, play quizzes & learn!',
                            gradient: LinearGradient(
                              colors: [
                                PalitabTheme.teal,
                                PalitabTheme.accentWarm,
                              ],
                            ),
                            onTap: () => Navigator.pushNamed(context, '/child-login'),
                            compact: isSmall,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Footer text
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Made with ❤️ for Filipino learners',
                        style: GoogleFonts.fredoka(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String emoji,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
    bool compact = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(compact ? 14 : 20),
        constraints: const BoxConstraints(minHeight: 145),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji circle
            Container(
              width: compact ? 60 : 70,
              height: compact ? 60 : 70,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: compact ? 34 : 40),
                ),
              ),
            ),
            SizedBox(width: compact ? 12 : 20),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.fredoka(
                      fontSize: compact ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.fredoka(
                      fontSize: compact ? 12 : 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Container(
              padding: EdgeInsets.all(compact ? 6 : 8),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
