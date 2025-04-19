import 'package:flutter/material.dart';
import '../api/NoteAPIService.dart';
import '../model/Note.dart';
import 'NoteDetailScreen.dart';
import 'NoteForm.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const NoteItem({
    required this.note,
    required this.onDelete,
    required this.onEdit,
  });

  Color _getPriorityColor() {
    switch (note.priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Hàm chuyển đổi chuỗi màu thành Color
  Color? _parseColor(String? color) {
    if (color == null) return null;
    // Loại bỏ ký tự # nếu có
    String hexColor = color.replaceAll('#', '');
    // Đảm bảo chuỗi có độ dài 6 hoặc 8 ký tự
    if (hexColor.length == 6) {
      hexColor = 'ff$hexColor'; // Thêm alpha channel (ff) nếu không có
    }
    try {
      return Color(int.parse('0x$hexColor'));
    } catch (e) {
      return null; // Trả về null nếu không parse được
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      color: _parseColor(note.color), // Sử dụng hàm _parseColor
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(
          note.content.length > 50 ? '${note.content.substring(0, 50)}...' : note.content,
        ),
        leading: CircleAvatar(
          backgroundColor: _getPriorityColor(),
          child: Text(note.priority.toString()),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoteForm(note: note)),
                );
                if (updated == true) onEdit();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Xác nhận xóa'),
                    content: Text('Bạn có chắc chắn muốn xóa ghi chú này?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await NoteAPIService.instance.deleteNote(note.id!);
                          Navigator.pop(ctx);
                          onDelete();
                        },
                        child: Text('Xóa'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteDetailScreen(note: note)),
          );
        },
      ),
    );
  }
}