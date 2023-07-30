import 'package:flutter/material.dart';
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
              onPressed: () {
                _saveNote();
              },
              child: Text('Zapisz'),
            ),
          ],
        ),
      ),
    );
  }

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
              onPressed: () {
                _deleteNote();
              },
              child: Text('Tak'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote() {
    // Wywołaj tutaj kod do usunięcia notatki, używając widget.note do dostępu do notatki
    // Po usunięciu notatki wróć do ekranu głównego
    Navigator.pop(context);
  }

  void _saveNote() {
    String title = _titleController.text;
    String content = _contentController.text;

    // Zapisz tutaj notatkę, używając widget.note do dostępu do notatki
    // Po zapisaniu notatki wróć do ekranu głównego
    Navigator.pop(context);
  }
}
