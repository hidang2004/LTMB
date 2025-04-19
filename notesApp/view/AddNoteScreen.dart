import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../api/NoteAPIService.dart';
import '../model/Note.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _priority = 1;
  List<String> _tags = [];
  String? _color;
  Color _selectedColor = Colors.white;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Color? _parseColor(String color) {
    try {
      String hexColor = color.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'ff$hexColor';
      }
      return Color(int.parse('0x$hexColor'));
    } catch (e) {
      return null;
    }
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn màu cho ghi chú'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                  _color = color.value.toRadixString(16).substring(2);
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Xong'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final note = Note(
        title: _titleController.text,
        content: _contentController.text,
        priority: _priority,
        createdAt: now,
        modifiedAt: now,
        tags: _tags.isNotEmpty ? _tags : null,
        color: _color,
      );

      try {
        await NoteAPIService.instance.createNote(note);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm ghi chú thành công'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm ghi chú mới'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Tiêu đề', border: OutlineInputBorder()),
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Nội dung', border: OutlineInputBorder()),
                maxLines: 5,
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập nội dung' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _priority,
                items: [
                  DropdownMenuItem(value: 1, child: Text('Thấp')),
                  DropdownMenuItem(value: 2, child: Text('Trung bình')),
                  DropdownMenuItem(value: 3, child: Text('Cao')),
                ],
                onChanged: (value) => setState(() => _priority = value!),
                decoration: InputDecoration(labelText: 'Ưu tiên', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nhãn (cách nhau bằng dấu phẩy)', border: OutlineInputBorder()),
                onChanged: (value) => _tags = value.split(',').map((e) => e.trim()).toList(),
                initialValue: _tags.join(', '),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Màu sắc: ${_color ?? "Chưa chọn"}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _openColorPicker,
                    child: Text('Chọn màu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('THÊM MỚI'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}