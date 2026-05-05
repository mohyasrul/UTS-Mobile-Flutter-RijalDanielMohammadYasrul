class LostItem {
  final String id;
  final String title;
  final String description;
  final String location;
  final String date;
  final String status; // 'Found' or 'Lost' or 'Claimed'
  final String category;
  final String contactInfo;

  const LostItem({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.status,
    required this.category,
    required this.contactInfo,
  });

  LostItem copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? date,
    String? status,
    String? category,
    String? contactInfo,
  }) {
    return LostItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      status: status ?? this.status,
      category: category ?? this.category,
      contactInfo: contactInfo ?? this.contactInfo,
    );
  }
}
