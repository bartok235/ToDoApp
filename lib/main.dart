import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_note_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _draggedNoteIndex;
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

  // Funkcja do usuwania notatki
  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      _saveNotes();
    });
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
          return Dismissible(
            key: Key(notes[index]),
            direction: DismissDirection.startToEnd, // Przeciąganie tylko w lewo
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              _deleteNote(index);
            },
            child: GestureDetector(
              // Obsługa przeciągania notatki
              onHorizontalDragStart: (details) {
                setState(() {
                  _draggedNoteIndex = index;
                });
              },
              onHorizontalDragUpdate: (details) {
                // Zmieniamy kolor tła notatki na czerwony podczas przeciągania
                setState(() {});
              },
              onHorizontalDragEnd: (details) {
                if (_draggedNoteIndex != null) {
                  _deleteNote(_draggedNoteIndex!);
                  setState(() {
                    _draggedNoteIndex = null;
                  });
                }
              },
              child: Card(
                color: _draggedNoteIndex == index ? Colors.red : null,
                child: ListTile(
                  title: Text(notes[index]),
                ),
              ),
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