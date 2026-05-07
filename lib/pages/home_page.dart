import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uts_pemrogramanmobile/pages/login_page.dart';
import 'package:uts_pemrogramanmobile/pages/profile_page.dart';
import 'package:uts_pemrogramanmobile/pages/item_details_page.dart';
import 'package:uts_pemrogramanmobile/pages/report_item_page.dart';
import 'package:uts_pemrogramanmobile/models/lost_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<LostItem> _items = List.from(dummyItems);
  List<LostItem> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = _items;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredItems = _items
          .where((item) =>
              item.title
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              item.location
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _addItem(LostItem item) {
    setState(() {
      _items.insert(0, item);
      _onSearchChanged(); // Update filtered list
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Lost & Found ITG'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.account_circle_outlined),
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
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginPage(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, Mahasiswa!',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ada barang yang hilang atau ditemukan hari ini?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(26),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.travel_explore_rounded,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari barang (misal: kunci, botol...)',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Aktivitas Terbaru',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_filteredItems.length != _items.length)
                  Text(
                    '${_filteredItems.length} hasil ditemukan',
                    style: TextStyle(
                        color: theme.colorScheme.primary, fontSize: 12),
                  ),
              ],
            ),
          ),

          // Items List
          Expanded(
            child: _filteredItems.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isFound = item.status == 'Found';
                      final isClaimed = item.status == 'Claimed';

                      return Hero(
                        tag: item.id,
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            onTap: () async {
                              final updatedItem =
                                  await Navigator.push<LostItem>(
                                context,
                                MaterialPageRoute<LostItem>(
                                  builder: (context) =>
                                      ItemDetailsPage(item: item),
                                ),
                              );

                              if (updatedItem != null) {
                                setState(() {
                                  final index = _items.indexWhere(
                                      (i) => i.id == updatedItem.id);
                                  if (index != -1) {
                                    _items[index] = updatedItem;
                                    _onSearchChanged(); // Refresh filtered list
                                  }
                                });
                              }
                            },
                            contentPadding: const EdgeInsets.all(12),
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isClaimed
                                    ? Colors.blue.withAlpha(26)
                                    : (isFound
                                        ? Colors.green.withAlpha(26)
                                        : Colors.orange.withAlpha(26)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: item.imageBytes != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(
                                        Uint8List.fromList(item.imageBytes!),
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      isClaimed
                                          ? Icons.verified_rounded
                                          : (isFound
                                              ? Icons
                                                  .check_circle_outline_rounded
                                              : Icons.help_outline_rounded),
                                      color: isClaimed
                                          ? Colors.blue
                                          : (isFound
                                              ? Colors.green
                                              : Colors.orange),
                                      size: 30,
                                    ),
                            ),
                            title: Text(
                              item.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(item.location,
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_outlined,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text('${item.date} ${item.time}',
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isClaimed
                                    ? Colors.blue.withAlpha(26)
                                    : (isFound
                                        ? Colors.green.withAlpha(26)
                                        : Colors.orange.withAlpha(26)),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isClaimed
                                      ? Colors.blue.withAlpha(51)
                                      : (isFound
                                          ? Colors.green.withAlpha(51)
                                          : Colors.orange.withAlpha(51)),
                                ),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  color: isClaimed
                                      ? Colors.blue[700]
                                      : (isFound
                                          ? Colors.green[700]
                                          : Colors.orange[700]),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final newItem = await Navigator.push<LostItem>(
            context,
            MaterialPageRoute(builder: (context) => const ReportItemPage()),
          );

          if (newItem != null) {
            _addItem(newItem);
            messenger.showSnackBar(
              const SnackBar(content: Text('Laporan berhasil dikirim!')),
            );
          }
        },
        label: const Text('Lapor Barang'),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.travel_explore_rounded,
              size: 80,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tidak ada barang ditemukan',
            style:
                TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
          ),
          Text(
            'Coba gunakan kata kunci lain',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

const List<LostItem> dummyItems = [
  LostItem(
    id: '1',
    title: 'Dompet Hitam',
    description:
        'Dompet kulit warna hitam, merk Eiger. Berisi KTP atas nama Rijal.',
    location: 'Lab Gedung D',
    date: '25/04/2026',
    time: '10:30',
    status: 'Found',
    category: 'Aksesoris',
    contactInfo: 'Satpam Gedung D',
  ),
  LostItem(
    id: '2',
    title: 'Botol Minum Biru',
    description:
        'Tumbler merk Tupperware warna biru navy, ada stiker logo ITG.',
    location: 'Parkir Satpam',
    date: '24/04/2026',
    time: '14:15',
    status: 'Lost',
    category: 'Lainnya',
    contactInfo: '08123456789 (Daniel)',
  ),
  LostItem(
    id: '3',
    title: 'Kacamata',
    description: 'Kacamata minus dengan frame besi warna silver.',
    location: 'Gedung Rektorat',
    date: '26/04/2026',
    time: '09:45',
    status: 'Found',
    category: 'Aksesoris',
    contactInfo: 'Resepsionis Rektorat',
  ),
];
