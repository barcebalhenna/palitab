import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'map_page.dart';
import 'reads_page.dart';
import 'quizzes_page.dart';
import 'profile_page.dart';

/// 🎮 Modern Child Home Wrapper with Gamified UI
/// Redesigned for ages 6-10 with engaging animations and intuitive navigation
class ChildHomeWrapper extends StatefulWidget {
  const ChildHomeWrapper({super.key});

  @override
  State<ChildHomeWrapper> createState() => _ChildHomeWrapperState();
}

class _ChildHomeWrapperState extends State<ChildHomeWrapper>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _xp = 85; // Current XP
  int _levelXpTarget = 150; // XP needed for next level
  int _currentLevel = 3;

  // Animation controllers
  late AnimationController _xpBarController;
  late AnimationController _starShineController;
  late AnimationController _navBounceController;
  late AnimationController _profilePulseController;

  // Pages
  final List<Widget> _pages = [
    MapLandingPage(),
    ReadsPage(),
    QuizzesPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentLevel = (_xp ~/ _levelXpTarget) + 1;

    // XP bar fill animation
    _xpBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    // Star shine animation (repeating)
    _starShineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Nav item bounce on tap
    _navBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Profile button pulse
    _profilePulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _xpBarController.dispose();
    _starShineController.dispose();
    _navBounceController.dispose();
    _profilePulseController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    _navBounceController.forward(from: 0);
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF5F7FA),

      // Modern header with gamified XP system
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: _buildModernAppBar(),
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.02, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _pages[_currentIndex],
      ),

      // Animated profile button
      floatingActionButton: _buildProfileButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Modern bottom navigation
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  Widget _buildModernAppBar() {
    final progress = _xp / _levelXpTarget;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PalitabTheme.accentWarm,
            PalitabTheme.accentHot,
            PalitabTheme.purple.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: PalitabTheme.accentHot.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Greeting with emoji
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _starShineController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_starShineController.value * 0.2),
                        child: const Text(
                          '🌟',
                          style: TextStyle(fontSize: 28),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Keep Exploring!',
                      style: GoogleFonts.fredoka(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedBuilder(
                    animation: _starShineController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_starShineController.value * 0.2),
                        child: const Text(
                          '🌟',
                          style: TextStyle(fontSize: 28),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Level and XP display
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    // Level indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.amber.shade400,
                                    Colors.orange.shade500,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.military_tech_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Level $_currentLevel',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AnimatedBuilder(
                              animation: _starShineController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1.0 + (_starShineController.value * 0.15),
                                  child: Icon(
                                    Icons.stars_rounded,
                                    color: Colors.yellow.shade300,
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$_xp XP',
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // Animated XP progress bar
                    Stack(
                      children: [
                        // Background track
                        Container(
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // Animated progress fill
                        AnimatedBuilder(
                          animation: _xpBarController,
                          builder: (context, child) {
                            return FractionallySizedBox(
                              widthFactor: progress * _xpBarController.value,
                              child: Container(
                                height: 18,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Color(0xFFFFEB3B),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${(progress * 100).toInt()}%',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: PalitabTheme.accentHot,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // XP to next level
                    Text(
                      '${_levelXpTarget - _xp} XP to Level ${_currentLevel + 1}!',
                      style: GoogleFonts.fredoka(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton() {
    return AnimatedBuilder(
      animation: _profilePulseController,
      builder: (context, child) {
        final scale = 1.0 + (_profilePulseController.value * 0.08);
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: () => _onNavItemTapped(3),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    PalitabTheme.purple,
                    PalitabTheme.accentHot,
                    PalitabTheme.accentWarm,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: PalitabTheme.accentHot.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 36,
                  color: _currentIndex == 3
                      ? PalitabTheme.accentHot
                      : Colors.grey[400],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernBottomNav() {
    final navItems = [
      {
        'icon': Icons.explore_rounded,
        'activeIcon': Icons.explore,
        'label': 'Explore',
        'color': Colors.blue,
      },
      {
        'icon': Icons.menu_book_rounded,
        'activeIcon': Icons.menu_book,
        'label': 'Stories',
        'color': Colors.purple,
      },
      {
        'icon': Icons.emoji_events_rounded,
        'activeIcon': Icons.emoji_events,
        'label': 'Quizzes',
        'color': Colors.orange,
      },
      {
        'icon': Icons.bar_chart_rounded,
        'activeIcon': Icons.bar_chart,
        'label': 'Progress',
        'color': Colors.green,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          color: Colors.white,
          elevation: 0,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side (2 items)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(navItems[0], 0),
                      _buildNavItem(navItems[1], 1),
                    ],
                  ),
                ),
                // Spacer for FAB
                const SizedBox(width: 30),
                // Right side (2 items)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(navItems[2], 2),
                      _buildNavItem(navItems[3], 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(Map<String, dynamic> item, int index) {
    final isActive = _currentIndex == index;
    final color = item['color'] as Color;

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ],
          )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(
                isActive
                    ? item['activeIcon'] as IconData
                    : item['icon'] as IconData,
                color: isActive ? color : Colors.grey[400],
                size: 28,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: GoogleFonts.fredoka(
                fontSize: isActive ? 13 : 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive ? color : Colors.grey[600],
              ),
              child: Text(
                item['label'] as String,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}