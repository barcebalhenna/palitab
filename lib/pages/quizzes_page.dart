import 'package:flutter/material.dart';

class QuizzesPage extends StatelessWidget {
  void _showFloatingMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating, // ✅ doesn't push FAB
        margin: const EdgeInsets.only(
          bottom: 80, // just above bottom navbar & FAB
          left: 16,
          right: 16,
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: [
          const Text(
            'Quizzes',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              title: const Text('Alamat ng Pinya - Quiz'),
              subtitle: const Text('WH questions • Multiple choice'),
              trailing: const Icon(Icons.play_arrow),
              onTap: () => _showFloatingMessage(context, 'Start quiz (placeholder)'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Phonics Drill'),
              subtitle: const Text('Vocabulary practice'),
              onTap: () => _showFloatingMessage(context, 'Start (placeholder)'),
            ),
          ),
        ],
      ),
    );
  }
}
