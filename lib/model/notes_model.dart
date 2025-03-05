class Note {
  String id;
  String subtitle;
  String title;
  String time;
  String due;
  String priority;
  int image;
  bool isDone;

  Note(
    this.id,
    this.subtitle,
    this.time,
    this.due,
    this.priority,
    this.image,
    this.title,
    this.isDone,
  );
}

enum PriorityLevel { low, medium, high }
