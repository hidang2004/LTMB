import 'package:intl/intl.dart';

class Note {
  int? id;
  String title;
  String content;
  int priority; // 1: Thấp, 2: Trung bình, 3: Cao
  DateTime createdAt;
  DateTime modifiedAt;
  List<String>? tags;
  String? color;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createdAt,
    required this.modifiedAt,
    this.tags,
    this.color,
  });

  // Named constructor từ Map
  Note.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        content = map['content'],
        priority = map['priority'],
        createdAt = DateTime.parse(map['createdAt']),
        modifiedAt = DateTime.parse(map['modifiedAt']),
        tags = map['tags'] != null ? List<String>.from(map['tags'].split(',')) : null,
        color = map['color'];

  // Chuyển thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'tags': tags?.join(','),
      'color': color,
    };
  }

  // Tạo bản sao với thuộc tính được cập nhật
  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? priority,
    DateTime? createdAt,
    DateTime? modifiedAt,
    List<String>? tags,
    String? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      tags: tags ?? this.tags,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, priority: $priority, createdAt: $createdAt, modifiedAt: $modifiedAt}';
  }
}