import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart'; // Zmień "your_app_name" na nazwę Twojej aplikacji
import 'note_model.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({super.key, required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

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
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  // Funkcja do potwierdzenia usunięcia notatki
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usuń notatkę'),
          content: const Text('Czy na pewno chcesz usunąć tę notatkę?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteNote(); // Wywołanie funkcji do usunięcia notatki
                // Wróć do ekranu głównego po usunięciu notatki
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Tak'),
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

    if (!mounted) return;
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Edytuj notatkę', style: TextStyle(color: Colors.grey)),
        actions: [
          IconButton(
            color: Colors.grey,
            icon: const Icon(Icons.delete),
            onPressed: () {
              _confirmDelete();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Tytuł', labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow), // Kolor dolnej granicy po kliknięciu
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Kolor dolnej granicy w stanie "spoczynku"
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Treść', labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow), // Kolor dolnej granicy po kliknięciu
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Kolor dolnej granicy w stanie "spoczynku"
                  ),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _updateNote(); // Wywołanie funkcji do aktualizacji notatki
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Kolor tła przycisku
              ),
              child: const Text('Zapisz', style: TextStyle(color: Colors.black54)),
            ),
          ],
        ),
      ),
    );
  }
}
