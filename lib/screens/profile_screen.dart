import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('screenshots/foto.png'),
          ),
            const SizedBox(height: 16),
            const Text(
              'Juberta Kalvarisman Waruwu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'NIM: 2415051051',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              'Prodi: Pendidikan Teknik Informatika (Undiksha)',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Divider(height: 40),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tema Project'),
              subtitle: const Text('BookFinder (Mobile Application Mini Project)'),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Tech Stack'),
              subtitle: const Text('Flutter, Dart, Provider, Open Library API, Supabase'),
            ),
          ],
        ),
      ),
    );
  }
}