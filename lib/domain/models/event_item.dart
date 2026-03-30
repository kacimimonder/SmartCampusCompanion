/// Domain model for campus events used by the Events tab.
class EventItem {
  const EventItem({required this.id, required this.title});

  final int id;
  final String title;

  /// Maps REST JSON into a strongly typed model.
  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Untitled event',
    );
  }
}
