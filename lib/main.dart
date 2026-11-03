import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart'; 
import 'pages/courses_page.dart';
import 'screens/favorites_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';

void main() {
  // INI ENDPOINT DARI DOSEN
  const String apiUrl = 'https://course-api-pearl.vercel.app'; 
  final dataSource = CourseApiService(apiUrl); 

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(CourseRepository(dataSource))..loadAll(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final _pages = const [HomePage(), CoursesPage(), FavoritesPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 840;
    return Scaffold(
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.list), label: Text('Courses')),
                NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorit')),
                NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profil')),
              ],
            ),
          Expanded(child: _pages[_index]),
        ],
      ),
      bottomNavigationBar: isWide ? null : NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorit'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}