import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'note_model.dart';

class DatabaseHelper {
  // Nazwa tabeli
  static final String tableNotes = 'notes';

  // Nazwy kolumn w tabeli
  static final String columnId = 'id';
  static final String columnTitle = 'title';
  static final String columnContent = 'content';

  // Singleton pattern - instancja bazy danych
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  // Getter do instancji bazy danych
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Inicjalizacja bazy danych
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableNotes (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnContent TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Metoda do dodawania notatki
  Future<int> insert(Note note) async {
    Database db = await instance.database;
    return await db.insert(tableNotes, note.toMap());
  }

  // Metoda do aktualizacji notatki
  Future<int> update(Note note) async {
    Database db = await instance.database;
    return await db.update(
      tableNotes,
      note.toMap(),
      where: '$columnId = ?',
      whereArgs: [note.id],
    );
  }

  // Metoda do usuwania notatki
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Metoda do pobierania wszystkich notatek
  Future<List<Note>> getAllNotes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableNotes);
    return List.generate(maps.length, (index) {
      return Note.fromMap(maps[index]);
    });
  }
}
