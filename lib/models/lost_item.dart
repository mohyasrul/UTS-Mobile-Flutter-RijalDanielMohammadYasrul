class LostItem {
  final String title;
  final String location;
  final String date;
  final String status; // 'Found' or 'Lost' or 'Claimed'

  const LostItem({
    required this.title,
    required this.location,
    required this.date,
    required this.status,
  });
}
