import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj notatkę'),
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

  void _saveNote() {
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

    // Zwracamy notatkę do poprzedniego ekranu
    Navigator.pop(context, title);
  }
}
