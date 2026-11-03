import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<CourseProvider>().student;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 60)),
            const SizedBox(height: 16),
            Text(s['name'] ?? 'Nama', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('NIM: ${s['nim'] ?? 'NIM'}', style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Skill Saya', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: ((s['skills'] as List<dynamic>?) ?? [])
                  .map((skill) => Chip(label: Text(skill.toString())))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}