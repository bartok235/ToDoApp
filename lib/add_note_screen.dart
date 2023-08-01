import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'note_model.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Funkcja do zapisywania notatki do bazy danych
  Future<void> _saveNote() async {
    String title = _titleController.text;
    String content = _contentController.text;

    // Jeśli tytuł nie został wpisany, użyj pierwszego słowa z treści jako tytuł
    if (title.isEmpty && content.isNotEmpty) {
      List<String> words = content.split(' ');
      if (words.isNotEmpty) {
        title = words[0];
      }
    } else if (title.isEmpty && content.isEmpty) {
      // Jeśli użytkownik nic nie wpisał zarówno do tytułu, jak i treści,
      // po prostu wracamy do poprzedniego ekranu
      Navigator.pop(context);
      return;
    }

    // Tworzymy nowy obiekt Note na podstawie wprowadzonych danych
    Note newNote = Note(title: title, content: content);

    // Korzystamy z DatabaseHelper, aby zapisać notatkę w bazie danych
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.insert(newNote);

    // Zwracamy notatkę do poprzedniego ekranu
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Dodaj notatkę', style: TextStyle(color: Colors.grey)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _titleController,
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
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _saveNote(); // Wywołanie funkcji do zapisu notatki
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
