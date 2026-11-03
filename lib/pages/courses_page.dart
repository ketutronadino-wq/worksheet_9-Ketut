import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/error_view.dart';
import '../screens/course_form_page.dart';
import '../screens/course_detail_page.dart';
import '../widgets/status_style.dart'; // Untuk banner

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CourseProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Mata Kuliah')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseFormPage())),
        child: const Icon(Icons.add),
      ),
      body: _body(context, p),
    );
  }

  Widget _body(BuildContext context, CourseProvider p) {
    if (p.isLoading) return const Center(child: CircularProgressIndicator());
    if (p.error != null) return ErrorView(message: p.error!, onRetry: p.loadAll);
    if (p.courses.isEmpty) return const Center(child: Text('Data kosong, silakan tambah.'));

    return Column(
      children: [
        // Banner Identitas
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
          child: Text('${p.student['nim']} - ${p.student['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: p.courses.length,
            itemBuilder: (context, i) {
              final c = p.courses[i];
              final st = statusStyle(c.status);
              return Card(
                child: ListTile(
                  leading: Icon(st.icon, color: st.color),
                  title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${c.code} • ${c.credits} SKS • ${st.label}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.favorite, color: Colors.red), onPressed: () => p.toggleFavorite(c.code)),
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseFormPage(course: c)))),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _hapus(context, c.id!, c.code)),
                    ],
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailPage(course: c))),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _hapus(BuildContext context, int id, String code) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(onPressed: () async {
            Navigator.pop(ctx);
            await context.read<CourseProvider>().deleteCourse(id, code);
          }, child: const Text('Hapus')),
        ],
      ),
    );
  }
}