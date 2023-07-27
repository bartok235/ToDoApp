import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_note_screen.dart'; // Dodaj import do pliku z ekranem dodawania notatki

void main() {
  runApp(MyApp());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> notes = [];
  @override
  void initState() {
    super.initState();
    _loadNotes(); // Wczytujemy notatki przy starcie aplikacji
  }

  // Funkcja do wczytania notatek z pamięci urządzenia
  void _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Wczytujemy notatki do listy notes
      notes = prefs.getStringList('notes') ?? [];
    });
  }

  // Funkcja do zapisywania notatki do pamięci urządzenia
  void _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Zapisujemy notatki przy użyciu SharedPreferences
    await prefs.setStringList('notes', notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo App'),
      ),
      body: notes.isEmpty
          ? Center(
        child: Text(
          'Brak notatek',
          style: TextStyle(fontSize: 20),
        ),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(notes[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddNoteScreen(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Funkcja do nawigowania na ekran dodawania notatki
  void _navigateToAddNoteScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNoteScreen()),
    );

    // Po powrocie z ekranu dodawania notatki, sprawdzamy, czy dodał notatkę
    if (result != null && result is String) {
      setState(() {
        // Dodajemy notatkę do listy notes
        notes.add(result);
        // Zapisujemy notatki lokalnie
        _saveNotes();
      });
    }
  }
}
