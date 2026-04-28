import 'package:flutter/material.dart';
import 'package:uts_pemrogramanmobile/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - Lost & Found ITG'),
        actions: [
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
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Home masih berupa placeholder untuk tahap Hari 1.\n\n'
            'Tahap berikutnya akan menambahkan data list barang hilang/temuan.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
