class Note {
  String title;
  String content;

  Note({
    required this.title,
    required this.content,
  });

  // Metoda do konwersji obiektu Note na mapę (potrzebne przy zapisie do SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }

  // Metoda do tworzenia obiektu Note z mapy (potrzebne przy odczycie z SharedPreferences)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
    );
  }
}
