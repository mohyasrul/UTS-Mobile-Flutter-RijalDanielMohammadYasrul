class LostItem {
  final String id;
  final String title;
  final String description;
  final String location;
  final String date;
  final String time;
  final String status; // 'Found' or 'Lost' or 'Claimed'
  final String category;
  final String contactInfo;
  final List<int>? imageBytes;

  const LostItem({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.status,
    required this.category,
    required this.contactInfo,
    this.imageBytes,
  });

  LostItem copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? date,
    String? time,
    String? status,
    String? category,
    String? contactInfo,
    List<int>? imageBytes,
  }) {
    return LostItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      category: category ?? this.category,
      contactInfo: contactInfo ?? this.contactInfo,
      imageBytes: imageBytes ?? this.imageBytes,
    );
  }
}
