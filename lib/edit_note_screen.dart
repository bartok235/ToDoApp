import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart'; // Zmień "your_app_name" na nazwę Twojej aplikacji
import 'note_model.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Wczytujemy tytuł i treść notatki, jeśli są dostępne
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
  }

  // Funkcja do aktualizacji notatki w bazie danych
  Future<void> _updateNote() async {
    String title = _titleController.text;
    String content = _contentController.text;

    // Aktualizujemy notatkę na podstawie wprowadzonych danych
    widget.note.title = title;
    widget.note.content = content;

    // Korzystamy z DatabaseHelper, aby zaktualizować notatkę w bazie danych
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.update(widget.note);

    // Zwracamy notatkę do poprzedniego ekranu
    Navigator.pop(context, widget.note);
  }

  // Funkcja do potwierdzenia usunięcia notatki
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Usuń notatkę'),
          content: Text('Czy na pewno chcesz usunąć tę notatkę?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Anuluj'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteNote(); // Wywołanie funkcji do usunięcia notatki
              },
              child: Text('Tak'),
            ),
          ],
        );
      },
    );
  }

// Funkcja do usunięcia notatki z bazy danych
  Future<void> _deleteNote() async {
    int? noteId = widget.note.id; // Pobieramy id notatki do usunięcia
    // Korzystamy z DatabaseHelper, aby usunąć notatkę z bazy danych
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.delete(noteId!);

    // Wróć do ekranu głównego po usunięciu notatki
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edytuj notatkę'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _confirmDelete();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tytuł',
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Treść',
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _updateNote(); // Wywołanie funkcji do aktualizacji notatki
              },
              child: Text('Zapisz'),
            ),
          ],
        ),
      ),
    );
  }
}
