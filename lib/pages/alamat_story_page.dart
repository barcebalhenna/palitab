import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../services/quiz_data_manager.dart';
import 'alamat_quiz_page.dart';

class AlamatStoryPage extends StatefulWidget {
  const AlamatStoryPage({super.key});

  @override
  State<AlamatStoryPage> createState() => _AlamatStoryPageState();
}

class _AlamatStoryPageState extends State<AlamatStoryPage>
    with TickerProviderStateMixin {
  List<dynamic> storyScenes = [];
  String storyTitle = '';
  bool isEnglish = true;
  int _currentPage = 0;
  late PageController _pageController;
  late AnimationController _pulseController;

  final _quizManager = QuizDataManager();
  static const _quizPath = 'assets/data/quizzes/alamat-ng-pinya-quiz.json';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Pulse animation for quiz button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _loadStoryData();
    _quizManager.preloadQuizData(_quizPath);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadStoryData() async {
    final jsonData = await rootBundle
        .loadString('assets/data/stories/alamat-ng-pinya.json');
    final data = jsonDecode(jsonData);
    setState(() {
      storyTitle = data['title']?.toString() ?? '';
      storyScenes = data['scenes'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (storyScenes.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                PalitabTheme.accentWarm.withOpacity(0.3),
                PalitabTheme.accentHot.withOpacity(0.3),
              ],
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    double progress = (_currentPage + 1) / storyScenes.length;
    final media = MediaQuery.of(context);
    final screenW = media.size.width;
    final screenH = media.size.height;
    // Base font size scales with width but clamp for extremes
    final baseFontSize = (screenW * 0.045).clamp(14.0, 22.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                PalitabTheme.accentWarm,
                PalitabTheme.accentHot,
              ],
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_stories, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                storyTitle,
                style: GoogleFonts.fredoka(
                  fontSize: (screenW * 0.055).clamp(16.0, 22.0),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          _buildProgressBar(progress),

          // Story pages
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: storyScenes.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final scene = storyScenes[index] ?? {};
                final rawText =
                ((isEnglish ? scene['en'] : scene['fil']) ?? '').toString();
                final imagePath = (scene['img'] ?? '').toString();

                final paragraphs = rawText
                    .split(RegExp(r'\r?\n'))
                    .map((p) => (p ?? '').toString().trim())
                    .where((p) => p.isNotEmpty)
                    .toList();

                // If this is the last page, we'll include the quiz section inside the
                // scrollable content so the button is at the very bottom.
                final bool isLastPage = index == storyScenes.length - 1;

                return _buildStoryPage(
                  index,
                  imagePath,
                  paragraphs,
                  baseFontSize,
                  screenW,
                  screenH,
                  isLastPage,
                );
              },
            ),
          ),

          // Page indicators
          _buildPageIndicators(),

          // Bottom bar
          _buildBottomControlBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '${_currentPage + 1}/${storyScenes.length}',
            style: GoogleFonts.fredoka(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: PalitabTheme.accentHot,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          PalitabTheme.accentWarm,
                          PalitabTheme.accentHot,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: PalitabTheme.accentHot.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: PalitabTheme.accentHot.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(progress * 100).round()}%',
              style: GoogleFonts.fredoka(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: PalitabTheme.accentHot,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryPage(
      int index,
      String imagePath,
      List<String> paragraphs,
      double baseFontSize,
      double screenW,
      double screenH,
      bool isLastPage,
      ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bottomSafe = MediaQuery.of(context).padding.bottom;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomSafe),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image (constrained)
              if (imagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: double.infinity,
                    // keep image height reasonable on small screens
                    height: (screenH * 0.32).clamp(140.0, 360.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              if (imagePath.isNotEmpty) const SizedBox(height: 16),

              // Decorative header
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          PalitabTheme.accentWarm,
                          PalitabTheme.accentHot,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEnglish ? 'Page ${index + 1}' : 'Pahina ${index + 1}',
                    style: GoogleFonts.fredoka(
                      fontSize: (screenW * 0.045).clamp(14.0, 20.0),
                      fontWeight: FontWeight.w600,
                      color: PalitabTheme.accentHot,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Story text
              ...paragraphs.map(
                    (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    p,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.nunito(
                      fontSize: baseFontSize,
                      height: 1.6,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),

              // If last page, show quiz CTA inside scroll area at the bottom
              if (isLastPage) ...[
                const SizedBox(height: 8),
                _buildInPageQuizSection(),
                // extra spacing so the button doesn't hide behind bottom bar
                SizedBox(height: (kToolbarHeight + 24)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInPageQuizSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Celebration message
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber.withOpacity(0.12),
                Colors.orange.withOpacity(0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.amber.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              const Text('🎉', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isEnglish
                      ? "Congratulations! You've finished the story!\nReady to test your knowledge?"
                      : "Binabati kita! Natapos mo ang kuwento!\nHanda ka na bang subukin ang iyong kaalaman?",
                  style: GoogleFonts.fredoka(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Animated quiz button (full width)
        ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.05).animate(
            CurvedAnimation(
              parent: _pulseController,
              curve: Curves.easeInOut,
            ),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  PalitabTheme.accentWarm,
                  PalitabTheme.accentHot,
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: PalitabTheme.accentHot.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlamatQuizPage(
                        isEnglish: isEnglish,
                        quizPath: _quizPath,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.quiz_rounded,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isEnglish ? "Start the Quiz!" : "Simulan ang Pagsusulit!",
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          storyScenes.length > 8 ? 8 : storyScenes.length,
              (index) {
            if (storyScenes.length > 8 && index == 7) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(
                  '...',
                  style: GoogleFonts.fredoka(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            final isActive = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 22 : 10,
              height: 10,
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                  colors: [
                    PalitabTheme.accentWarm,
                    PalitabTheme.accentHot,
                  ],
                )
                    : null,
                color: isActive ? null : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                boxShadow: isActive
                    ? [
                  BoxShadow(
                    color: PalitabTheme.accentHot.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Language toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildLanguageButton('🇬🇧 EN', isEnglish, () {
                    setState(() => isEnglish = true);
                  }),
                  _buildLanguageButton('🇵🇭 FIL', !isEnglish, () {
                    setState(() => isEnglish = false);
                  }),
                ],
              ),
            ),

            // Navigation buttons
            Row(
              children: [
                if (_currentPage > 0)
                  _buildNavButton(
                    Icons.arrow_back_rounded,
                        () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),

                const SizedBox(width: 10),

                if (_currentPage < storyScenes.length - 1)
                  _buildNavButton(
                    Icons.arrow_forward_rounded,
                        () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
            colors: [
              PalitabTheme.accentWarm,
              PalitabTheme.accentHot,
            ],
          )
              : null,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PalitabTheme.accentWarm,
            PalitabTheme.accentHot,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: PalitabTheme.accentHot.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
