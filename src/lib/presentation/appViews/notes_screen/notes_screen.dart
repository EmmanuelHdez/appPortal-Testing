import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:src/dependency_injection_container.dart';
import 'package:src/presentation/appViews/logout_screen.dart';
import 'package:src/presentation/appViews/notes_screen/widgets/notes_widget.dart';
import 'package:src/presentation/appViews/notes_screen/bloc/notes_bloc.dart';
import 'package:src/presentation/routes/app_routes.dart';
import 'package:src/presentation/shared/loading_widget.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotesBloc>(),
      child: Builder(builder: (context) {
        final bloc = context.watch<NotesBloc>();
        return Scaffold(
          body: BlocBuilder<NotesBloc, NotesState>(
            builder: (context, state) {
              if (state is NotesInitial) {
                _makeRequest(context);
              } else if (state is NotesLoading) {
                return const LoadingWidget();
              } else if (state is UnreadNotesLoaded) {
                return NotesWidget(
                  notesModel: state.notesModel,
                  patientName: state.patientName,
                );
              } else if (state is NoteMarkedAsSeen) {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  Navigator.pushNamed(
                    context,
                    '${AppRoutes.notesPage}/details',
                    arguments: state.noteData,
                  );
                });
              } else if (state is NotesError) {
                if (state.message == 401 || state.message == '401') {
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LogoutScreen()),
                      (Route<dynamic> route) => false,
                    );
                  });
                } else {
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    _showErrorModal('Sorry, something went wrong', context);
                  });
                }
              }
              return Container();
            },
          ),
        );
      }),
    );
  }

  void _makeRequest(BuildContext context) {
    context.read<NotesBloc>().add(FetchUnreadNotes());
  }

  void _showErrorModal(String message, BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: message,
    );
  }
}
