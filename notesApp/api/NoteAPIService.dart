import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/Note.dart';

class NoteAPIService {
  static final NoteAPIService instance = NoteAPIService._init();
  static Database? _database;

  NoteAPIService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      priority INTEGER NOT NULL,
      createdAt TEXT NOT NULL,
      modifiedAt TEXT NOT NULL,
      tags TEXT,
      color TEXT
    )
    ''');
  }

  Future<Note> createNote(Note note) async {
    final db = await database;
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'modifiedAt DESC');
    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final result = await db.query('notes', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty ? Note.fromMap(result.first) : null;
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Note>> getNotesByPriority(int priority) async {
    final db = await database;
    final result = await db.query('notes', where: 'priority = ?', whereArgs: [priority]);
    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    final result = await db.query('notes',
        where: 'title LIKE ? OR content LIKE ?', whereArgs: ['%$query%', '%$query%']);
    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}