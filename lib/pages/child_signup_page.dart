import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// 🎨 Modern Child Signup Page - Multi-step onboarding
/// Designed for ages 6-12 with playful, engaging UX
class ChildSignupPage extends StatefulWidget {
  const ChildSignupPage({super.key});

  @override
  State<ChildSignupPage> createState() => _ChildSignupPageState();
}

class _ChildSignupPageState extends State<ChildSignupPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final TextEditingController _parentEmailController = TextEditingController();

  // Selected values
  String? _selectedAvatar;
  int? _selectedAge;
  bool _termsAccepted = false;

  // Animation controllers
  late AnimationController _celebrationController;
  late AnimationController _progressController;

  // Avatar options
  final List<String> _avatars = ['🦁', '🐼', '🦊', '🐸', '🐰', '🦄', '🐱', '🐶'];

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _celebrationController.dispose();
    _progressController.dispose();
    _usernameController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    _parentEmailController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _totalSteps - 1) {
        setState(() => _currentStep++);
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _progressController.forward(from: 0);
      } else {
        _completeSignup();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Avatar selection
        if (_selectedAvatar == null) {
          _showError('Pick your favorite character! 🎭');
          return false;
        }
        return true;
      case 1: // Username
        if (_usernameController.text.isEmpty) {
          _showError('Choose a cool username! ✨');
          return false;
        }
        if (_usernameController.text.length < 3) {
          _showError('Username should be at least 3 characters! 📝');
          return false;
        }
        return true;
      case 2: // PIN
        if (_pinController.text.isEmpty || _confirmPinController.text.isEmpty) {
          _showError('Create your secret PIN! 🔐');
          return false;
        }
        if (_pinController.text.length != 4) {
          _showError('PIN should be 4 numbers! 🔢');
          return false;
        }
        if (_pinController.text != _confirmPinController.text) {
          _showError('PINs don\'t match! Try again! 🔄');
          return false;
        }
        return true;
      case 3: // Parent email & terms
        if (_parentEmailController.text.isEmpty) {
          _showError('We need your parent\'s email! 📧');
          return false;
        }
        if (!_termsAccepted) {
          _showError('Please ask your parent to accept the terms! 📋');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('😊', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.fredoka(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _completeSignup() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Creating your account...',
                style: GoogleFonts.fredoka(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate account creation
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // Close loading dialog
      _showSuccessAndNavigate();
    }
  }

  void _showSuccessAndNavigate() {
    _celebrationController.forward();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildSuccessDialog(),
    ).then((_) {
      Navigator.pushReplacementNamed(context, '/child');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              PalitabTheme.accentWarm.withOpacity(0.8),
              PalitabTheme.accentHot.withOpacity(0.8),
              PalitabTheme.purple.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with progress
              _buildHeader(),

              // Step content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildAvatarStep(),
                    _buildUsernameStep(),
                    _buildPinStep(),
                    _buildParentInfoStep(),
                  ],
                ),
              ),

              // Navigation buttons
              _buildNavigationButtons(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              if (_currentStep > 0)
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _previousStep,
                )
              else
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: GoogleFonts.fredoka(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Step ${_currentStep + 1} of $_totalSteps',
                      style: GoogleFonts.fredoka(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Row(
            children: List.generate(
              _totalSteps,
                  (index) => Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(
                    right: index < _totalSteps - 1 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index <= _currentStep
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '🎭',
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 20),
          Text(
            'Pick Your Character!',
            style: GoogleFonts.fredoka(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Choose your favorite buddy for your adventure',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _avatars.length,
            itemBuilder: (context, index) {
              final avatar = _avatars[index];
              final isSelected = _selectedAvatar == avatar;
              return GestureDetector(
                onTap: () => setState(() => _selectedAvatar = avatar),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? PalitabTheme.accentHot
                          : Colors.transparent,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? PalitabTheme.accentHot.withOpacity(0.4)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: isSelected ? 16 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      avatar,
                      style: TextStyle(fontSize: isSelected ? 48 : 40),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            _selectedAvatar ?? '😊',
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 20),
          Text(
            'What\'s Your Name?',
            style: GoogleFonts.fredoka(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Choose a cool username!',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'SuperReader123',
                    hintStyle: GoogleFonts.fredoka(
                      color: Colors.grey[400],
                      fontSize: 24,
                    ),
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.person_rounded,
                      size: 32,
                      color: PalitabTheme.purple,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tip: Use letters, numbers, or mix them up!',
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '🔐',
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 20),
          Text(
            'Create Your Secret PIN',
            style: GoogleFonts.fredoka(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Make a 4-number code to keep your account safe!',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                // PIN input
                TextField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••',
                    hintStyle: GoogleFonts.fredoka(
                      color: Colors.grey[300],
                      fontSize: 32,
                    ),
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: PalitabTheme.teal,
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_rounded,
                      color: PalitabTheme.teal,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Confirm PIN
                TextField(
                  controller: _confirmPinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••',
                    hintStyle: GoogleFonts.fredoka(
                      color: Colors.grey[300],
                      fontSize: 32,
                    ),
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: PalitabTheme.purple,
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_clock_rounded,
                      color: PalitabTheme.purple,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Choose numbers you\'ll remember! Like your favorite number!',
                          style: GoogleFonts.fredoka(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '👨‍👩‍👧‍👦',
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 20),
          Text(
            'Ask Your Parent!',
            style: GoogleFonts.fredoka(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We need to send them an email to keep you safe',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Parent email
                Text(
                  'Parent\'s Email',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _parentEmailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'parent@email.com',
                    hintStyle: GoogleFonts.fredoka(
                      color: Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: PalitabTheme.accentHot,
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.email_rounded,
                      color: PalitabTheme.accentHot,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Age selection (optional)
                Text(
                  'How old are you?',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(7, (index) {
                    final age = index + 6; // Ages 6-12
                    final isSelected = _selectedAge == age;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAge = age),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                            colors: [
                              PalitabTheme.accentWarm,
                              PalitabTheme.accentHot,
                            ],
                          )
                              : null,
                          color: isSelected ? null : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '$age',
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // Terms checkbox
                GestureDetector(
                  onTap: () => setState(() => _termsAccepted = !_termsAccepted),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _termsAccepted
                          ? PalitabTheme.accentWarm.withOpacity(0.1)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _termsAccepted
                            ? PalitabTheme.accentWarm
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _termsAccepted
                                ? PalitabTheme.accentWarm
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _termsAccepted
                                  ? PalitabTheme.accentWarm
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                          ),
                          child: _termsAccepted
                              ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 20,
                          )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'My parent agrees to the Terms & Privacy Policy',
                            style: GoogleFonts.fredoka(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              flex: 1,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _previousStep,
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _nextStep,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentStep < _totalSteps - 1
                              ? 'Continue'
                              : 'Create Account!',
                          style: GoogleFonts.fredoka(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: PalitabTheme.accentHot,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentStep < _totalSteps - 1
                              ? Icons.arrow_forward_rounded
                              : Icons.celebration_rounded,
                          color: PalitabTheme.accentHot,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated success icon
            ScaleTransition(
              scale: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _celebrationController,
                  curve: Curves.elasticOut,
                ),
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      PalitabTheme.accentWarm,
                      PalitabTheme.accentHot,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '🎉 Welcome Aboard! 🎉',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: PalitabTheme.accentHot,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your account is ready!\nLet\'s start your adventure!',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    PalitabTheme.accentWarm,
                    PalitabTheme.accentHot,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.rocket_launch_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Let\'s Go!',
                          style: GoogleFonts.fredoka(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}