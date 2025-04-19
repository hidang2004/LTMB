import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/Note.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết ghi chú'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16),
            Text('Nội dung:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(note.content),
            SizedBox(height: 16),
            Text('Ưu tiên: ${note.priority}'),
            SizedBox(height: 16),
            Text('Thời gian tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(note.createdAt)}'),
            SizedBox(height: 8),
            Text('Thời gian sửa: ${DateFormat('dd/MM/yyyy HH:mm').format(note.modifiedAt)}'),
            if (note.tags != null && note.tags!.isNotEmpty) ...[
              SizedBox(height: 16),
              Text('Nhãn:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                children: note.tags!.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}