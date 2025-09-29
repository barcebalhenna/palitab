import 'package:flutter/material.dart';
import '../theme.dart';

class TeacherLoginPage extends StatefulWidget {
  @override
  _TeacherLoginPageState createState() => _TeacherLoginPageState();
}

class _TeacherLoginPageState extends State<TeacherLoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? errorMessage;

  void _login() {
    if (_email.text == 'teacher@example.com' && _password.text == '1234') {
      Navigator.pushReplacementNamed(context, '/teacher');
    } else {
      setState(() {
        errorMessage = 'Invalid credentials. Try teacher@example.com / 1234';
      });
    }
  }

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
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.school, size: 80, color: PalitabTheme.pureWhite),
                const SizedBox(height: 20),
                const Text(
                  'Parent / Teacher Login',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: PalitabTheme.pureWhite,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: PalitabTheme.pureWhite,
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: PalitabTheme.pureWhite,
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PalitabTheme.purple,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _login,
                  child: const Text('Login', style: TextStyle(fontSize: 18)),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('← Back to Role Selection',
                      style: TextStyle(color: PalitabTheme.pureWhite)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
