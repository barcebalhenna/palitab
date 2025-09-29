import 'package:flutter/material.dart';
import '../theme.dart';

class TeacherDashboardPage extends StatefulWidget {
  @override
  _TeacherDashboardPageState createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  final TextEditingController _pin = TextEditingController();
  bool _authorized = false;

  void _checkPin() {
    setState(() {
      _authorized = _pin.text.trim() == '1234';
    });
    if (!_authorized) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Wrong PIN')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent / Teacher Dashboard'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _authorized ? _buildDashboardBody() : _buildPinBody(),
      ),
    );
  }

  Widget _buildPinBody() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Enter PIN to view student progress',
          style: TextStyle(fontSize: 18)),
      const SizedBox(height: 20),
      TextField(
        controller: _pin,
        keyboardType: TextInputType.number,
        obscureText: true,
        decoration: const InputDecoration(
            labelText: 'PIN', border: OutlineInputBorder()),
      ),
      const SizedBox(height: 12),
      ElevatedButton(onPressed: _checkPin, child: const Text('Unlock')),
    ],
  );

  Widget _buildDashboardBody() => ListView(
    children: [
      _infoTile('Total Reading Time (this week)', '1 hr 24 min'),
      _infoTile('Vocabulary Words Mastered', '18 words'),
      _infoTile('Quiz Performance (avg)', '85%'),
      const SizedBox(height: 12),
      Card(
        child: ListTile(
          leading: const Icon(Icons.mic),
          title: const Text('Listen to last recorded retell'),
          subtitle: const Text('Student: Juan D. — 00:45'),
          trailing: const Icon(Icons.play_arrow),
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Play (placeholder)'))),
        ),
      ),
    ],
  );

  Widget _infoTile(String title, String value) => Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      tileColor: Colors.white,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Text(value,
          style: const TextStyle(fontSize: 16, color: PalitabTheme.teal)),
    ),
  );
}
