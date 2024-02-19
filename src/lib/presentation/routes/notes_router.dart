import 'package:flutter/material.dart';
import 'package:src/data/model/notes_model.dart';
import 'package:src/presentation/appViews/notes_screen/notes_screen.dart';
import 'package:src/presentation/appViews/note_details_screen/note_details_screen.dart';

class NotesRouter extends StatelessWidget {
  const NotesRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(onGenerateRoute: (notes) {
        switch (notes.name) {
          case '/notes_screen/details':
            final noteData = notes.arguments as NoteModel?;
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    NoteDetailsScreen(noteDataArgs: noteData));
          default:
            return MaterialPageRoute(
                builder: (BuildContext context) => const NotesScreen());
        }
      }),
    );
  }
}
