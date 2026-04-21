/// Domain model for announcement data shown in the campus news feed.
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
  });

  final int id;
  final String title;
  final String body;

  /// Maps REST JSON into a strongly typed model.
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'No title',
      body: json['body'] as String? ?? 'No details',
    );
  }

  /// Converts this model into a map so it can be stored in SQLite tables.
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'body': body};
  }
}
