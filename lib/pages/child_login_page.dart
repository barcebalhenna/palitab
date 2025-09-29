import 'package:flutter/material.dart';
import '../theme.dart';

class ChildLoginPage extends StatefulWidget {
  @override
  _ChildLoginPageState createState() => _ChildLoginPageState();
}

class _ChildLoginPageState extends State<ChildLoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _pin = TextEditingController();
  String? errorMessage;

  void _login() {
    if (_username.text == 'child1' && _pin.text == '1111') {
      Navigator.pushReplacementNamed(context, '/child');
    } else {
      setState(() {
        errorMessage = 'Invalid credentials. Try child1 / 1111';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [PalitabTheme.teal, PalitabTheme.purple],
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
                const Icon(Icons.child_care,
                    size: 80, color: PalitabTheme.pureWhite),
                const SizedBox(height: 20),
                const Text(
                  'Child Login',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: PalitabTheme.pureWhite,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _username,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: PalitabTheme.pureWhite,
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _pin,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: PalitabTheme.pureWhite,
                    labelText: 'PIN',
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
                    backgroundColor: PalitabTheme.accentWarm,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _login,
                  child: const Text('Start Reading!',
                      style: TextStyle(fontSize: 18, color: Colors.black)),
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
