import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/data/model/notes_model.dart';
import 'package:src/dependency_injection_container.dart';
import 'package:src/presentation/appViews/note_details_screen/widgets/note_details_widget.dart';
import 'package:src/presentation/appViews/notes_screen/bloc/notes_bloc.dart';

class NoteDetailsScreen extends StatelessWidget {
  final NoteModel? noteDataArgs;
  final bool notificationTap;
  

  const NoteDetailsScreen({
    required this.noteDataArgs,
    this.notificationTap = false,
    Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(noteDataArgs);
    return Scaffold(
      body: BlocProvider(create: (_) => sl<NotesBloc>(),
      child: NoteDetailsWidget(noteData: noteDataArgs, notificationTap: notificationTap,),
      ),
    );
  }
}