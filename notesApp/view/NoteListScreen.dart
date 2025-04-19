import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/NoteAPIService.dart';
import '../model/Note.dart';
import 'NoteForm.dart';
import 'NoteItem.dart';
import 'LoginScreen.dart';

class NoteListScreen extends StatefulWidget {
  final Function? onLogout; // Thêm tham số onLogout

  const NoteListScreen({this.onLogout, Key? key}) : super(key: key);

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late Future<List<Note>> _notesFuture;
  bool _isGridView = false;
  int? _priorityFilter;

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _notesFuture = _priorityFilter == null
          ? NoteAPIService.instance.getAllNotes()
          : NoteAPIService.instance.getNotesByPriority(_priorityFilter!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách ghi chú'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'refresh') {
                _refreshNotes();
              } else if (value.startsWith('priority')) {
                setState(() {
                  _priorityFilter = int.tryParse(value.split(':')[1]);
                  _refreshNotes();
                });
              } else if (value == 'logout') {
                _showLogoutDialog();
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(value: 'refresh', child: Text('Làm mới')),
              PopupMenuItem(value: 'priority:1', child: Text('Ưu tiên thấp')),
              PopupMenuItem(value: 'priority:2', child: Text('Ưu tiên trung bình')),
              PopupMenuItem(value: 'priority:3', child: Text('Ưu tiên cao')),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Đăng xuất'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Chưa có ghi chú nào'));
          } else {
            return _isGridView
                ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => NoteItem(
                note: snapshot.data![index],
                onDelete: _refreshNotes,
                onEdit: _refreshNotes,
              ),
            )
                : ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => NoteItem(
                note: snapshot.data![index],
                onDelete: _refreshNotes,
                onEdit: _refreshNotes,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteForm()),
          );
          if (created == true) _refreshNotes();
        },
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Xác nhận đăng xuất'),
        content: Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (widget.onLogout != null) {
                widget.onLogout!(); // Gọi onLogout từ tham số
              }
            },
            child: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}