import 'package:flutter/material.dart';
import '../theme.dart';

class MapLandingPage extends StatefulWidget {
  @override
  _MapLandingPageState createState() => _MapLandingPageState();
}

class _MapLandingPageState extends State<MapLandingPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> stories = [
    {'title': 'Alamat ng Pinya', 'xp': 0, 'locked': false, 'image': 'assets/images/ggi_alamatngpinya.png'},
    {'title': 'The Monkey and the Turtle', 'xp': 50, 'locked': false, 'image': 'assets/images/ggi_monkey-turtle.png'},
    {'title': 'Maria Makiling', 'xp': 100, 'locked': false, 'image': 'assets/images/ggi_mariamakiling.png'},
    {'title': 'Ibong Adarna', 'xp': 150, 'locked': true, 'image': 'assets/images/cloud2.png'},
    {'title': 'Malakas at Maganda', 'xp': 200, 'locked': true, 'image': 'assets/images/cloud2.png'},
  ];

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(); // continuous loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      PalitabTheme.accentHot,
      PalitabTheme.purple,
      PalitabTheme.teal,
      PalitabTheme.accentWarm,
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFDE7), Color(0xFFB3E5FC)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/map_bg.png"),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            reverse: true, // start from bottom
            child: SizedBox(
              height: 900,
              child: Stack(
                children: [
                  // Curvy winding path
                  CustomPaint(
                    size: const Size(double.infinity, double.infinity),
                    painter: _PathPainter(),
                  ),

                  // Story nodes
                  ...List.generate(stories.length, (i) {
                    final s = stories[i];
                    final isUnlocked = !s['locked'];
                    final baseColor = colors[i % colors.length];

                    final anchors = [
                      Offset(MediaQuery.of(context).size.width * 0.2, 830), // bottom start
                      Offset(MediaQuery.of(context).size.width * 0.65, 760),
                      Offset(MediaQuery.of(context).size.width * 0.20, 600),
                      Offset(MediaQuery.of(context).size.width * 0.75, 420),
                      Offset(MediaQuery.of(context).size.width * 0.25, 200),
                    ];

                    final anchor = anchors[i];

                    return Positioned(
                      left: anchor.dx - 40, // center horizontally
                      top: anchor.dy - 40,  // center vertically
                      child: GestureDetector(
                        onTap: isUnlocked ? () {
                          Navigator.pushNamed(context, '/alamat');
                        } : null,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedScale(
                                  scale: isUnlocked ? (1.0 + 0.05 * _controller.value) : 1.0,
                                  duration: const Duration(milliseconds: 400),
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    padding: const EdgeInsets.all(4),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Animated border ring
                                        if (isUnlocked)
                                          Transform.rotate(
                                            angle: _controller.value * 6.2832, // 2π radians
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: SweepGradient(
                                                  colors: [
                                                    baseColor,
                                                    baseColor.withOpacity(0.7),
                                                    Colors.white.withOpacity(0.8),
                                                    baseColor,
                                                  ],
                                                  stops: const [0.0, 0.3, 0.6, 1.0],
                                                ),
                                              ),
                                            ),
                                          ),

                                        // Inner avatar / lock
                                        Container(
                                          margin: const EdgeInsets.all(4), // space for border
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: s['locked'] ? Colors.grey[400] : Colors.white,
                                            boxShadow: [
                                              if (isUnlocked)
                                                BoxShadow(
                                                  color: baseColor.withOpacity(
                                                      0.5 * (0.5 + _controller.value)),
                                                  blurRadius: 20,
                                                  spreadRadius: 3,
                                                ),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child: s['locked']
                                                ? Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              color: Colors.grey[400], // full gray circle
                                              child: Center(
                                                child: Icon(
                                                  Icons.lock,
                                                  color: Colors.black54,
                                                  size: 35, // ✅ lock stays small
                                                ),
                                              ),
                                            )
                                                : Image.asset(
                                              s['image'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 120, // control width so text wraps nicely under the circle
                                  child: Text(
                                    s['title'],
                                    textAlign: TextAlign.center,
                                    softWrap: true,           // allows wrapping
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: s['locked'] ? Colors.black54 : Colors.black87,
                                    ),
                                  ),
                                ),

                                if (s['locked'])
                                  Text(
                                    "Unlock at ${s['xp']} XP",
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black54),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Draws a playful winding path (curvy + thicker + gradient)
class _PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.orange.shade200, Colors.white, Colors.teal.shade200],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 40
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    double stepY = size.height / 5;

    // Start at bottom
    path.moveTo(size.width * 0.2, size.height);

    // Smooth wave-like path upward
    for (int i = 1; i <= 5; i++) {
      double controlX = (i % 2 == 0) ? size.width * 0.05 : size.width * 0.95;
      double controlY = size.height - stepY * (i - 0.5);

      double endX = size.width / 2;
      double endY = size.height - stepY * i;

      path.quadraticBezierTo(controlX, controlY, endX, endY);

      // Add footsteps along path
      canvas.drawCircle(
        Offset(endX, endY),
        4,
        Paint()..color = Colors.yellow.shade600,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
