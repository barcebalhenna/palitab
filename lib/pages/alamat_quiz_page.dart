import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../services/quiz_data_manager.dart';

class AlamatQuizPage extends StatefulWidget {
  final bool isEnglish;
  final String quizPath;

  const AlamatQuizPage({
    super.key,
    required this.isEnglish,
    required this.quizPath,
  });

  @override
  State<AlamatQuizPage> createState() => _AlamatQuizPageState();
}

class _AlamatQuizPageState extends State<AlamatQuizPage>
    with TickerProviderStateMixin {
  List<dynamic> _selectedQuestions = []; // 10 random questions
  int _currentQuestionIndex = 0;
  int _score = 0;
  String _difficulty = 'easy'; // Hidden from user, used for adaptive logic
  bool _quizCompleted = false;
  bool _isLoading = true;
  bool _showCorrectFeedback = false;
  bool _showIncorrectFeedback = false;

  final _quizManager = QuizDataManager();
  final int _totalQuizQuestions = 10; // Show only 10 questions

  // All questions grouped by difficulty (for adaptive selection)
  Map<String, List<dynamic>> _questionsByDifficulty = {
    'easy': [],
    'medium': [],
    'hard': [],
  };

  // Animation controllers
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadQuizData();
  }

  void _initAnimations() {
    // Slide animation for question transitions
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Bounce animation for buttons
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadQuizData() async {
    try {
      final data = await _quizManager.loadQuizData(widget.quizPath);
      final lang = widget.isEnglish ? 'english' : 'filipino';
      final allQuestions = data['questions'][lang] as List<dynamic>;

      // Normalize Filipino difficulty levels
      for (var q in allQuestions) {
        if (q['language'] == 'filipino') {
          switch (q['difficulty'].toString().toLowerCase()) {
            case 'madali':
              q['difficulty'] = 'easy';
              break;
            case 'katamtaman':
              q['difficulty'] = 'medium';
              break;
            case 'mahirap':
              q['difficulty'] = 'hard';
              break;
          }
        }
      }

      // Group questions by normalized difficulty
      final questionsByDiff = <String, List<dynamic>>{
        'easy': allQuestions
            .where((q) => q['difficulty'].toString().toLowerCase() == 'easy')
            .toList(),
        'medium': allQuestions
            .where((q) => q['difficulty'].toString().toLowerCase() == 'medium')
            .toList(),
        'hard': allQuestions
            .where((q) => q['difficulty'].toString().toLowerCase() == 'hard')
            .toList(),
      };

      // Select 10 random questions
      final selectedQuestions = _selectRandomQuestions(questionsByDiff);

      setState(() {
        _questionsByDifficulty = questionsByDiff;
        _selectedQuestions = selectedQuestions;
        _isLoading = false;
      });

      _slideController.forward();
    } catch (e) {
      debugPrint('Error loading quiz data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorDialog();
      }
    }
  }

  List<dynamic> _selectRandomQuestions(
      Map<String, List<dynamic>> questionsByDiff) {
    final random = Random();
    final selected = <dynamic>[];

    final easyPool = List.from(questionsByDiff['easy'] ?? [])..shuffle(random);
    final mediumPool = List.from(questionsByDiff['medium'] ?? [])
      ..shuffle(random);
    final hardPool = List.from(questionsByDiff['hard'] ?? [])..shuffle(random);

    selected.addAll(easyPool.take(4));
    selected.addAll(mediumPool.take(4));
    selected.addAll(hardPool.take(2));

    final firstThree = selected.sublist(0, 3);
    final rest = selected.sublist(3)..shuffle(random);
    return [...firstThree, ...rest];
  }

  void _answerQuestion(bool correct) async {
    setState(() {
      if (correct) {
        _showCorrectFeedback = true;
        _score++;
      } else {
        _showIncorrectFeedback = true;
      }
    });

    if (correct && _difficulty == 'easy') {
      _difficulty = 'medium';
    } else if (correct && _difficulty == 'medium') {
      _difficulty = 'hard';
    } else if (!correct && _difficulty == 'hard') {
      _difficulty = 'medium';
    } else if (!correct && _difficulty == 'medium') {
      _difficulty = 'easy';
    }

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _showCorrectFeedback = false;
      _showIncorrectFeedback = false;
    });

    if (_currentQuestionIndex < _selectedQuestions.length - 1) {
      _slideController.reset();
      setState(() => _currentQuestionIndex++);
      _slideController.forward();
    } else {
      setState(() => _quizCompleted = true);
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          widget.isEnglish ? '😕 Oops!' : '😕 Naku!',
          style: GoogleFonts.fredoka(fontSize: 24),
        ),
        content: Text(
          widget.isEnglish
              ? 'Failed to load quiz. Please try again.'
              : 'Hindi ma-load ang pagsusulit. Subukan muli.',
          style: GoogleFonts.fredoka(fontSize: 18),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PalitabTheme.accentWarm,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              _loadQuizData();
            },
            child: Text(
              widget.isEnglish ? 'Retry' : 'Subukan Muli',
              style: GoogleFonts.fredoka(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return _buildResultPage();
    }

    if (_isLoading || _selectedQuestions.isEmpty) {
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(strokeWidth: 5),
                const SizedBox(height: 24),
                Text(
                  widget.isEnglish
                      ? '🎯 Preparing your quiz...'
                      : '🎯 Hinihanda ang pagsusulit...',
                  style: GoogleFonts.fredoka(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentQ = _selectedQuestions[_currentQuestionIndex];
    final isMCQ = currentQ['type'] == 'multiple choice';
    final options = (currentQ['options'] ?? []).cast<String>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  PalitabTheme.accentWarm.withOpacity(0.15),
                  PalitabTheme.accentHot.withOpacity(0.15),
                  Colors.purple.withOpacity(0.1),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildModernHeader(),
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildQuestionCard(currentQ, isMCQ, options),
                  ),
                ),
              ],
            ),
          ),
          if (_showCorrectFeedback) _buildFeedbackOverlay(true),
          if (_showIncorrectFeedback) _buildFeedbackOverlay(false),
        ],
      ),
    );
  }

  Widget _buildModernHeader() {
    final progress = (_currentQuestionIndex + 1) / _totalQuizQuestions;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 28),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.isEnglish ? 'Question' : 'Tanong',
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${_currentQuestionIndex + 1}/$_totalQuizQuestions',
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: PalitabTheme.accentHot,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        valueColor:
                        AlwaysStoppedAnimation(PalitabTheme.accentHot),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '$_score',
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Updated card layout
  Widget _buildQuestionCard(
      Map<dynamic, dynamic> currentQ, bool isMCQ, List<String> options) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.75,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: PalitabTheme.accentHot.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PalitabTheme.accentWarm.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Text('❓', style: TextStyle(fontSize: 36)),
              ),
              const SizedBox(height: 10),
              Text(
                currentQ['question'],
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 28),
              if (isMCQ)
                ...options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isCorrect = option == currentQ['answer'];
                  final colors = [
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.purple
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildAnswerButton(
                      option,
                          () => _answerQuestion(isCorrect),
                      colors[index % colors.length],
                    ),
                  );
                }),
              if (currentQ['type'] == 'true/false')
                Row(
                  children: [
                    Expanded(
                      child: _buildAnswerButton(
                        widget.isEnglish ? '✓ True' : '✓ Tama',
                            () => _answerQuestion(
                          currentQ['answer'].toString().toLowerCase() ==
                              'true' ||
                              currentQ['answer'].toString().toLowerCase() ==
                                  'tama',
                        ),
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAnswerButton(
                        widget.isEnglish ? '✗ False' : '✗ Mali',
                            () => _answerQuestion(
                          currentQ['answer'].toString().toLowerCase() ==
                              'false' ||
                              currentQ['answer'].toString().toLowerCase() ==
                                  'mali',
                        ),
                        Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(
      String text, VoidCallback onPressed, Color color) {
    return GestureDetector(
      onTapDown: (_) => _bounceController.forward(),
      onTapUp: (_) => _bounceController.reverse(),
      onTapCancel: () => _bounceController.reverse(),
      child: ScaleTransition(
        scale: _bounceAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackOverlay(bool correct) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: (correct ? Colors.green : Colors.red).withOpacity(0.3),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(correct ? '🎉' : '💪',
                    style: const TextStyle(fontSize: 80)),
                const SizedBox(height: 16),
                Text(
                  correct
                      ? (widget.isEnglish ? 'Correct!' : 'Tama!')
                      : (widget.isEnglish ? 'Keep trying!' : 'Subukan pa!'),
                  style: GoogleFonts.fredoka(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: correct ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultPage() {
    final percentage = (_score / _totalQuizQuestions * 100).round();
    final isPerfect = _score == _totalQuizQuestions;
    final isGood = percentage >= 70;
    final isOkay = percentage >= 50;

    String emoji, title, subtitle;
    Color primaryColor;

    if (isPerfect) {
      emoji = '🏆';
      title = widget.isEnglish ? 'PERFECT!' : 'PERPEKTO!';
      subtitle = widget.isEnglish
          ? "You're a superstar!"
          : "Ang galing mo!";
      primaryColor = Colors.amber;
    } else if (isGood) {
      emoji = '⭐';
      title = widget.isEnglish ? 'Great Job!' : 'Magaling!';
      subtitle = widget.isEnglish ? 'Keep it up!' : 'Ipagpatuloy mo!';
      primaryColor = Colors.green;
    } else if (isOkay) {
      emoji = '👍';
      title = widget.isEnglish ? 'Good Try!' : 'Ayos!';
      subtitle =
      widget.isEnglish ? 'Practice more!' : 'Mag-practice pa!';
      primaryColor = Colors.blue;
    } else {
      emoji = '💪';
      title = widget.isEnglish ? 'Keep Practicing!' : 'Magpatuloy!';
      subtitle =
      widget.isEnglish ? "You'll get better!" : "Mas gagaling ka pa!";
      primaryColor = Colors.orange;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.2),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Trophy/emoji
                  TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Text(emoji, style: const TextStyle(fontSize: 90)),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  Text(
                    title,
                    style: GoogleFonts.fredoka(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    subtitle,
                    style: GoogleFonts.fredoka(
                      fontSize: 22,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Score display
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.isEnglish ? 'Your Score' : 'Iyong Iskor',
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_score/$_totalQuizQuestions',
                          style: GoogleFonts.fredoka(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: GoogleFonts.fredoka(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Buttons
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_stories, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          widget.isEnglish
                              ? 'Back to Story'
                              : 'Bumalik sa Kuwento',
                          style: GoogleFonts.fredoka(
                            fontSize: 20,
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
        ),
      ),
    );
  }
}