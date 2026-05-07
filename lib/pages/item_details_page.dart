import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:uts_pemrogramanmobile/models/lost_item.dart';

class ItemDetailsPage extends StatelessWidget {
  final LostItem item;

  const ItemDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFound = item.status == 'Found';
    final isClaimed = item.status == 'Claimed';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Detail Barang'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image / Hero Section
            Hero(
              tag: item.id,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: isClaimed
                      ? Colors.blue.withAlpha(26)
                      : (isFound
                          ? Colors.green.withAlpha(26)
                          : Colors.orange.withAlpha(26)),
                ),
                child: item.imageBytes != null
                    ? ClipRRect(
                        child: Image.memory(
                          Uint8List.fromList(item.imageBytes!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              isClaimed
                                  ? Icons.verified_rounded
                                  : (isFound
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.help_outline_rounded),
                              size: 100,
                              color: isClaimed
                                  ? Colors.blue
                                  : (isFound ? Colors.green : Colors.orange),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          isClaimed
                              ? Icons.verified_rounded
                              : (isFound
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.help_outline_rounded),
                          size: 100,
                          color: isClaimed
                              ? Colors.blue
                              : (isFound ? Colors.green : Colors.orange),
                        ),
                      ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isClaimed
                              ? Colors.blue
                              : (isFound ? Colors.green : Colors.orange),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '${item.date} ${item.time}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.category,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle(theme, 'Deskripsi'),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle(theme, 'Lokasi'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(item.location, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Contact Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Kontak',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  theme.colorScheme.primary.withAlpha(26),
                              child: Icon(Icons.person,
                                  color: theme.colorScheme.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Pelapor',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  Text(item.contactInfo,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.chat_bubble_outline_rounded),
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: FilledButton.icon(
          onPressed: isClaimed
              ? null
              : () {
                  final String newStatus = isFound ? 'Claimed' : 'Found';
                  final updatedItem = item.copyWith(status: newStatus);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isFound
                          ? 'Permintaan klaim dikirim!'
                          : 'Status barang diperbarui menjadi Ditemukan!'),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );

                  Navigator.pop(context, updatedItem);
                },
          icon: Icon(isClaimed
              ? Icons.verified_user_rounded
              : (isFound
                  ? Icons.handshake_rounded
                  : Icons.check_circle_rounded)),
          label: Text(isClaimed
              ? 'Barang Sudah Selesai'
              : (isFound ? 'Klaim Barang Ini' : 'Saya Menemukannya')),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
