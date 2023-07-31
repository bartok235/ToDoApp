import 'package:flutter/material.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';
import 'note_model.dart';
import 'database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ToDo App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _draggedNoteIndex;
  List<Note> notes = []; // Teraz notes będzie listą obiektów klasy Note

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Wczytujemy notatki przy starcie aplikacji
  }

  // Funkcja do wczytania notatek z bazy danych
  void _loadNotes() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<Note> loadedNotes = await databaseHelper.getAllNotes();

    setState(() {
      // Wczytujemy notatki do listy notes
      notes = loadedNotes;
    });
  }

// Funkcja do zapisywania notatki do bazy danych
  void _saveNote(Note note) async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.insert(note);

    // Odśwież listę notatek po dodaniu nowej notatki do bazy danych
    _loadNotes();
  }


  // Funkcja do aktualizacji notatki w bazie danych
  void _updateNote(Note note) async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.update(note);

    setState(() {
      // Aktualizujemy notatkę w liście notes
      int index = notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        notes[index] = note;
      }
    });
  }

  // Funkcja do usunięcia notatki z bazy danych
  void _deleteNote(int index) async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.delete(notes[index].id!);

    setState(() {
      // Usuwamy notatkę z listy notes
      notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
      ),
      body: notes.isEmpty
          ? const Center(
        child: Text(
          'Brak notatek',
          style: TextStyle(fontSize: 20),
        ),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(notes[index].id.toString()),
            direction: DismissDirection.startToEnd, // Przeciąganie tylko w lewo
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: const Icon(
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
              onTap: () {
                _navigateToEditNoteScreen(context, index);
              },
              child: Card(
                color: _draggedNoteIndex == index ? Colors.red : null,
                child: ListTile(
                  title: Text(notes[index].title),
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
        child: const Icon(Icons.add),
      ),
    );
  }

  // Funkcja do nawigowania na ekran edycji notatki
  void _navigateToEditNoteScreen(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(note: notes[index]),
      ),
    );

    // Po powrocie z ekranu edycji notatki, sprawdzamy, czy zmodyfikowano notatkę
    if (result != null && result is Note) {
      _updateNote(result);
    }
    _loadNotes();
  }

  // Funkcja do nawigowania na ekran dodawania notatki
  void _navigateToAddNoteScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNoteScreen()),
    );

    // Po powrocie z ekranu dodawania notatki, sprawdzamy, czy dodał notatkę
    if (result != null && result is Note) {
      _saveNote(result);
      //Dodajemy notatkę do listy notes
      setState(() {
        notes.add(result);
      });
    }
    _loadNotes();

  }
}
