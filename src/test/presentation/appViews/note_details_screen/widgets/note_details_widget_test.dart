import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/intl.dart';
import 'package:src/presentation/appViews/notes_screen/bloc/notes_bloc.dart';
import 'package:src/domain/usecase/notes/fetch_unread_notes_use_case.dart';
import 'package:src/domain/usecase/notes/create_note_use_case.dart';
import 'package:src/domain/usecase/notes/mark_as_seen_use_case.dart';
import 'package:src/data/model/notes_model.dart';
import 'package:src/presentation/appViews/note_details_screen/widgets/note_details_widget.dart';

class MockFetchUnreadNotesUseCase extends Mock
    implements FetchUnreadNotesUseCase {}

class MockCreateNoteUseCase extends Mock implements CreateNoteUseCase {}

class MockMarkAsSeenUseCase extends Mock implements MarkAsSeenUseCase {}

void main() {
  testWidgets('NoteDetailsWidget UI Test with no related task', (WidgetTester tester) async {
    final mockFetchUnreadNotesUseCase = MockFetchUnreadNotesUseCase();
    final mockCreateNoteUseCase = MockCreateNoteUseCase();
    final mockMarkAsSeenUseCase = MockMarkAsSeenUseCase();

    NoteModel testNoteData = NoteModel(
      id: 22559,
      created: DateTime.parse("2023-02-03T18:01:51.000Z"),
      noteType: "Clinical",
      privateNote: false,
      noteSubject: "appointmentNote",
      notes:
          "\n                              Status: Completed;\n                              Psychiatrist: first test test_doctor;\n                              Treatment: Anxiety;\n                              Date: Thu 2nd February 2023;\n                              Time: 09:15:00 PM;\n                              Appointment link: https://puk-meetup-dev.herokuapp.com/47052?token=kYXHoSIApZ6O4s2XJOO2_;\n                              Secure PIN: 540144;\n                              second test appointment",
      legacyCustomerId: null,
      legacyId: null,
      seenAt: null,
      sopCodes: null,
      sopCodesHistory: null,
      comments: [],
      attachments: [],
      addedBy: AddedBy(
        id: 47052,
        firstName: "JAvila",
        lastName: "Superadmin01",
        azureObjectId: null,
        jobTitle: "Portal Admin",
        department: "Information Technology",
      ),
      seenBy: null,
      formCollections: [],
      task: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider(
            create: (context) => NotesBloc(
              mockFetchUnreadNotesUseCase,
              mockCreateNoteUseCase,
              mockMarkAsSeenUseCase,
            ),
            child: NoteDetailsWidget(
              noteData: testNoteData,
            ),
          ),
        ),
      ),
    );

    String _getDaySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return 'th';
      }

      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    String formatDateNote(String dateString) {
      DateTime dateTime = DateTime.parse(dateString);

      String day = DateFormat('d').format(dateTime);
      String month = DateFormat('MMMM').format(dateTime);
      String year = DateFormat('y').format(dateTime);
      String time = DateFormat('jm').format(dateTime);

      String daySuffix = _getDaySuffix(int.parse(day));

      return '$day$daySuffix $month $year, $time';
    }

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    expect(find.text('Portal Notes'), findsOneWidget);

    String dateString = formatDateNote(testNoteData.created.toString());
    Finder dateFinder = find.byWidgetPredicate(
      (Widget widget) => widget.toString().contains(dateString),
    );
    expect(dateFinder, findsOneWidget);

    String authorString = '${testNoteData.addedBy?.firstName} ${testNoteData.addedBy?.lastName}';
    Finder authorFinder = find.byWidgetPredicate(
      (Widget widget) => widget.toString().contains(authorString),
    );
    expect(authorFinder, findsOneWidget);

    String subjectString = 'Subject: ${testNoteData.noteSubject}';
    Finder subjectFinder = find.byWidgetPredicate(
      (Widget widget) => widget.toString().contains(subjectString),
    );
    expect(subjectFinder, findsOneWidget);

    final subjectWidget = tester.widget<RichText>(subjectFinder);
    final subjectText = subjectWidget.text.toPlainText();
    dynamic noteTextContentTrimmed = testNoteData!.notes!
        .trim()
        .replaceAll("\n                              ", "\n");
    dynamic noteTextContentSpaced =
        noteTextContentTrimmed.trim().replaceAll(RegExp(r'\s+'), ' ');
    dynamic noteTextContent =
        noteTextContentSpaced.trim().replaceAll("; ", ":\n");

    expect(subjectText.contains(noteTextContent), isTrue);
    
    if (testNoteData.addedBy?.department != null){
      String regardingString = 'Kind Regards,';
      Finder regardingFinder = find.byWidgetPredicate(
        (Widget widget) => widget.toString().contains(regardingString),
      );
      expect(regardingFinder, findsOneWidget);

      String departmentString = '${testNoteData.addedBy?.department}';
      Finder departmentFinder = find.byWidgetPredicate(
        (Widget widget) => widget.toString().contains(departmentString),
      );
      expect(departmentFinder, findsOneWidget);
    }

    final noteKeyboardFinder = find.byKey(const Key('noteKeyboard'));
    expect(noteKeyboardFinder, findsNothing);

    //back arrow functionality
    final backArrowWidget = find.byKey(const Key('backArrowBtn'));
    expect(backArrowWidget, findsOneWidget);
  });

  testWidgets('NoteDetailsWidget UI Test with related task', (WidgetTester tester) async {
    final mockFetchUnreadNotesUseCase = MockFetchUnreadNotesUseCase();
    final mockCreateNoteUseCase = MockCreateNoteUseCase();
    final mockMarkAsSeenUseCase = MockMarkAsSeenUseCase();

    NoteModel testNoteData = NoteModel(
      id: 22996,
      created: DateTime.parse("2023-02-28T20:06:12.000Z"),
      noteType: "patientSubmittedNote",
      privateNote: false,
      noteSubject: "test",
      notes: "test",
      legacyCustomerId: null,
      legacyId: null,
      seenAt: null,
      sopCodes: null,
      sopCodesHistory: null,
      comments: [],
      attachments: [],
      addedBy: AddedBy(
        id: 47055,
        firstName: "First test",
        lastName: "patient_1",
        azureObjectId: null,
        jobTitle: null,
        department: null,
      ),
      seenBy: null,
      formCollections: [],
      task: Task(
        id: 10825,
        taskAssignedUser: 47053,
        note: 22996,
        assignedUser: AssignedUser(
          id: 47053,
          firstName: "first test",
          lastName: "test_doctor",
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider(
            create: (context) => NotesBloc(
              mockFetchUnreadNotesUseCase,
              mockCreateNoteUseCase,
              mockMarkAsSeenUseCase,
            ),
            child: NoteDetailsWidget(
              noteData: testNoteData,
            ),
          ),
        ),
      ),
    );

    final keyboardElement = find.byKey(const Key('noteKeyboard'));
    expect(keyboardElement, findsOneWidget);

    await tester.enterText(keyboardElement, 'Text to reply note');
    expect(find.text('Text to reply note'), findsOneWidget);

    final sendBtnWidget = find.byKey(const Key('sendNoteReplyBtn'));
    expect(sendBtnWidget, findsOneWidget);
    await tester.pumpAndSettle();
  });
}
