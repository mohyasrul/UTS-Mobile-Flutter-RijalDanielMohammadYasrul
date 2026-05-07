import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uts_pemrogramanmobile/models/lost_item.dart';

class ReportItemPage extends StatefulWidget {
  const ReportItemPage({super.key});

  @override
  State<ReportItemPage> createState() => _ReportItemPageState();
}

class _ReportItemPageState extends State<ReportItemPage> {
  final _formKey = GlobalKey<FormState>();
  String _status = 'Lost';
  String _category = 'Elektronik';

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();

  final List<String> _categories = [
    'Elektronik',
    'Dokumen',
    'Aksesoris',
    'Pakaian',
    'Alat Tulis',
    'Lainnya'
  ];

  Uint8List? _previewImageBytes;
  Uint8List? _compressedImageBytes;
  bool _isUploading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndProcessImage() async {
    // Capture context-dependent values before async operations
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      setState(() => _isUploading = true);

      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image == null) {
        setState(() => _isUploading = false);
        return;
      }

      // Read image bytes
      final imageBytes = await image.readAsBytes();

      Uint8List resultBytes;

      if (kIsWeb) {
        // Skip compression on web
        resultBytes = imageBytes;
      } else {
        // Compress image from bytes
        final compressed = await FlutterImageCompress.compressWithList(
          imageBytes,
          minWidth: 500,
          minHeight: 500,
          quality: 70,
        );
        resultBytes = Uint8List.fromList(compressed);
      }

      setState(() {
        _previewImageBytes = imageBytes;
        _compressedImageBytes = resultBytes;
        _isUploading = false;
      });
    } catch (e) {
      setState(() => _isUploading = false);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Gagal memproses gambar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Lapor Barang'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Toggle
              Text('Jenis Laporan', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                      value: 'Lost',
                      label: Text('Hilang'),
                      icon: Icon(Icons.search)),
                  ButtonSegment(
                      value: 'Found',
                      label: Text('Ditemukan'),
                      icon: Icon(Icons.check_circle)),
                ],
                selected: {_status},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _status = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Image Picker
              Text('Foto Barang (Opsional)', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _isUploading ? null : _pickAndProcessImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
              child: _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : _previewImageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(_previewImageBytes!,
                              fit: BoxFit.cover),
                        )
                      : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined,
                                    size: 40, color: Colors.grey[400]),
                                const SizedBox(height: 8),
                                Text('Tap untuk menambah foto',
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  hintText: 'Misal: Kunci Motor, iPhone 13',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Nama barang wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locCtrl,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  hintText: 'Misal: Kantin, Gedung C Lantai 2',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Lokasi wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Tambahan',
                  hintText: 'Ciri-ciri barang, warna, dsb.',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contactCtrl,
                decoration: const InputDecoration(
                  labelText: 'Kontak yang Bisa Hubungi',
                  hintText: 'No. WA atau ID Line',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Kontak wajib diisi' : null,
              ),
              const SizedBox(height: 32),

              FilledButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final now = DateTime.now();
                    final dateStr = '${now.day}/${now.month}/${now.year}';
                    final timeStr =
                        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

                    final newItem = LostItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleCtrl.text,
                      description: _descCtrl.text,
                      location: _locCtrl.text,
                      date: dateStr,
                      time: timeStr,
                      status: _status,
                      category: _category,
                      contactInfo: _contactCtrl.text,
                      imageBytes: _compressedImageBytes,
                    );

                    Navigator.pop(context, newItem);
                  }
                },
                child: const Text('Kirim Laporan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
