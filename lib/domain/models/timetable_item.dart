/// Domain model representing one timetable task/class item.
class TimetableItem {
  const TimetableItem({
    required this.id,
    required this.title,
    required this.completed,
  });

  final int id;
  final String title;
  final bool completed;

  /// Maps REST JSON into a strongly typed model.
  factory TimetableItem.fromJson(Map<String, dynamic> json) {
    return TimetableItem(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Untitled class',
      completed: json['completed'] as bool? ?? false,
    );
  }
}
