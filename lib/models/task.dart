class Task {
  int? id;
  String text;
  bool isCompleted;
  DateTime? createdAt;

  Task({
    this.id,
    required this.text,
    this.isCompleted = false,
    this.createdAt,
  });
}