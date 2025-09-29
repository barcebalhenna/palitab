import 'package:flutter/material.dart';
import '../theme.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: [
          Row(
            children: [
              const CircleAvatar(
                  radius: 36,
                  backgroundColor: PalitabTheme.purple,
                  child: Icon(Icons.person, color: Colors.white, size: 36)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Juan D.',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Grade 2'),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          const Card(child: ListTile(title: Text('Total XP'), trailing: Text('20'))),
          const Card(
              child:
              ListTile(title: Text('Stories Completed'), trailing: Text('1'))),
          const Card(
              child: ListTile(
                  title: Text('Weekly Reading Time'),
                  trailing: Text('1 hr 24 min'))),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => showModalBottomSheet(
                context: context, builder: (_) => _settingsSheet(context)),
          )
        ],
      ),
    );
  }

  Widget _settingsSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 240,
      child: Column(
        children: [
          ListTile(
              title: const Text('Language: English'),
              trailing: Switch(value: true, onChanged: (_) {})),
          ListTile(
              title: const Text('Audio narration'),
              trailing: Switch(value: true, onChanged: (_) {})),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'))
        ],
      ),
    );
  }
}
