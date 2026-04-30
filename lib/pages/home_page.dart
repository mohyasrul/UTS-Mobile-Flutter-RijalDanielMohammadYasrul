import 'package:flutter/material.dart';
import 'package:uts_pemrogramanmobile/pages/login_page.dart';
import 'package:uts_pemrogramanmobile/pages/profile_page.dart';
import 'package:uts_pemrogramanmobile/models/lost_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - Lost & Found ITG'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const ProfilePage(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Daftar Temuan & Kehilangan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: dummyItems.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = dummyItems[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(item.status[0])),
                    title: Text(item.title),
                    subtitle: Text('${item.location} • ${item.date}'),
                    trailing: Text(item.status),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const List<LostItem> dummyItems = [
    LostItem(
      title: 'Dompet Hitam',
      location: 'Perpustakaan Lantai 2',
      date: '25/04/2026',
      status: 'Found',
    ),
    LostItem(
      title: 'Botol Minum Biru',
      location: 'Lapangan Basket',
      date: '24/04/2026',
      status: 'Lost',
    ),
    LostItem(
      title: 'Kacamata',
      location: 'Kantin Tengah',
      date: '26/04/2026',
      status: 'Found',
    ),
  ];
}
