import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/status_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CourseProvider>();
    final total = p.courses.length;
    final doneCount = p.courses.where((c) => c.status == 'done').length;
    final activeCount = p.courses.where((c) => c.status == 'active').length;
    final totalCredits = p.courses.fold<int>(0, (s, c) => s + c.credits);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identitas
            Card(
              child: ListTile(
                leading: const Icon(Icons.person, size: 40),
                title: Text(p.student['name'] ?? studentName),
                subtitle: Text('NIM: ${p.student['nim'] ?? studentId}'),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Ringkasan Belajar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // Statistik Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _card(Icons.menu_book, Colors.blue, '$total', 'Mata Kuliah'),
                _card(Icons.stars, Colors.purple, '$totalCredits', 'Total SKS'),
                _card(Icons.check_circle, Colors.green, '$doneCount', 'Selesai'),
                _card(Icons.hourglass_top, Colors.orange, '$activeCount', 'Aktif'),
              ],
            ),
            const SizedBox(height: 20),
            // Favorit Card
            Card(
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red, size: 30),
                title: Text('${p.favorites.length} Course Favorit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(IconData icon, Color color, String val, String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 6),
            Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}