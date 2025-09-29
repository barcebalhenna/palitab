import 'package:flutter/material.dart';
import '../theme.dart';
import 'map_page.dart';
import 'reads_page.dart';
import 'quizzes_page.dart';
import 'profile_page.dart';

class ChildHomeWrapper extends StatefulWidget {
  @override
  _ChildHomeWrapperState createState() => _ChildHomeWrapperState();
}

class _ChildHomeWrapperState extends State<ChildHomeWrapper>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  int xp = 85; // Example XP
  int levelXpTarget = 150; // XP needed for next level

  late AnimationController _controller;

  final pages = <Widget>[
    MapLandingPage(),
    ReadsPage(),
    QuizzesPage(),
    ProfilePage(), // Later replace with a real Stats page if needed
  ];

  @override
  void initState() {
    super.initState();
    // Controller for looping gradient animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = xp / levelXpTarget;

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.pink, PalitabTheme.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        "🌟 Keep Going, Explorer!",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level ${(xp ~/ levelXpTarget) + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 20),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '$xp / $levelXpTarget XP',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 14,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: pages[_index],

      // Floating Profile Button with animated gradient
      floatingActionButton: GestureDetector(
        onTap: () => setState(() => _index = 3),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    PalitabTheme.accentWarm,
                    PalitabTheme.teal,
                    Colors.pinkAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  transform: GradientRotation(_controller.value * 2 * 3.1416),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: PalitabTheme.accentWarm, // Always colorful
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: _buildCustomNavBar(),
    );
  }

  Widget _buildCustomNavBar() {
    final items = [
      {'icon': Icons.map, 'label': 'Map'},
      {'icon': Icons.menu_book, 'label': 'Reads'},
      {'icon': Icons.quiz, 'label': 'Quizzes'},
      {'icon': Icons.bar_chart, 'label': 'Stats'},
    ];

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: PalitabTheme.softCream,
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(2, (i) {
                final isActive = _index == i;
                return _buildNavItem(items[i], isActive, () {
                  setState(() => _index = i);
                });
              }),
            ),
          ),
          const SizedBox(width: 60),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(2, (i) {
                final pageIndex = i + 2;
                final isActive = _index == pageIndex;
                return _buildNavItem(items[pageIndex], isActive, () {
                  setState(() => _index = pageIndex);
                });
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      Map<String, Object> item, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? PalitabTheme.accentWarm.withOpacity(0.9)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item['icon'] as IconData,
              size: 22,
              color: isActive ? PalitabTheme.pureWhite : Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              item['label'] as String,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? PalitabTheme.pureWhite : Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
