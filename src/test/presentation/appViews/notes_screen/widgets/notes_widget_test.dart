import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/data/model/notes_model.dart';
import 'package:src/presentation/appViews/notes_screen/widgets/notes_widget.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets('NotesWidget when patient has no unread notes', (WidgetTester tester) async {
    dynamic jsonData = {
      "total": 0,
      "limit": 1000,
      "offset": 0,
      "records": [],
    };

    NotesModel notesModel = NotesModel.fromJson(jsonData);

    await tester.pumpWidget(
      MaterialApp(
        home: NotesWidget(
          notesModel: notesModel,
          patientName: 'John Doe',
        ),
      ),
    );
    
    expect(find.text('Hi, John Doe 👋'), findsOneWidget);
    expect(find.text('You do not have any unread notes.'), findsOneWidget);
    expect(find.text('Unread portal notes'), findsOneWidget);
  });

  testWidgets('NotesWidget when patient has unread notes', (WidgetTester tester) async {
    dynamic jsonData = {
      "total": 2,
      "limit": 1000,
      "offset": 0,
      "records": [
        {
          "id": 22559,
          "created": "2023-02-03T18:01:51.000Z",
          "noteType": "Clinical",
          "privateNote": false,
          "noteSubject": "appointmentNote",
          "notes": "\n                              Status: Completed;\n                              Psychiatrist: first test test_doctor;\n                              Treatment: Anxiety;\n                              Date: Thu 2nd February 2023;\n                              Time: 09:15:00 PM;\n                              Appointment link: https://puk-meetup-dev.herokuapp.com/47052?token=kYXHoSIApZ6O4s2XJOO2_;\n                              Secure PIN: 540144;\n                              second test appointment",
          "legacyCustomerId": null,
          "legacyId": null,
          "seenAt": null,
          "notesHTML": null,
          "notesJSON": null,
          "sopCodes": null,
          "sopCodesHistory": null,
          "comments": [],
          "attachments": [],
          "AddedBy": {
            "id": 47052,
            "firstName": "JAvila",
            "lastName": "Superadmin01",
            "azureObjectId": null,
            "jobTitle": "Portal Admin",
            "department": "Information Technology"
          },
          "SeenBy": null,
          "FormCollections": [],
          "Task": null
        },
        {
          "id": 22995,
          "created": "2023-02-28T20:01:41.000Z",
          "noteType": "patientSubmittedNote",
          "privateNote": false,
          "noteSubject": "test",
          "notes": "test note",
          "legacyCustomerId": null,
          "legacyId": null,
          "seenAt": null,
          "notesHTML": null,
          "notesJSON": null,
          "sopCodes": null,
          "sopCodesHistory": null,
          "comments": [],
          "attachments": [],
          "AddedBy": {
            "id": 47055,
            "firstName": "First test",
            "lastName": "patient_1",
            "azureObjectId": null,
            "jobTitle": null,
            "department": null
          },
          "SeenBy": null,
          "FormCollections": [],
          "Task": {
            "id": 10824,
            "assignedUser": 47053,
            "note": 22995,
            "AssignedUser": {
              "id": 47053,
              "firstName": "first test",
              "lastName": "test_doctor",
              "userType": "psychiatrist"
            }
          }
        }
      ],
    };

    NotesModel notesModel = NotesModel.fromJson(jsonData);
    String patientName = 'John Doe';

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

    await tester.pumpWidget(
      MaterialApp(
        home: NotesWidget(
          notesModel: notesModel,
          patientName: 'John Doe',
        ),
      ),
    );

    expect(find.text('Hi, ${patientName} 👋'), findsOneWidget);
    expect(find.text('You currently have ${notesModel.records?.length} unread portal notes'), findsOneWidget);
    expect(find.text('View and respond to them below'), findsOneWidget);
    expect(find.text('Unread portal notes'), findsOneWidget);

    notesModel.records?.forEach((record) {
      String noteDateString = formatDateNote(record.created.toString());
      Finder noteDateFinder = find.byWidgetPredicate(
        (Widget widget) => widget.toString().contains(noteDateString),
      );
      expect(noteDateFinder, findsOneWidget);

      String authorString = '${record.addedBy?.firstName} ${record.addedBy?.lastName}';
      Finder authorFinder = find.byWidgetPredicate(
        (Widget widget) => widget.toString().contains(authorString),
      );
      expect(authorFinder, findsOneWidget);

      String subjectString = 'Subject: ${record.noteSubject}';
      Finder subjectFinder = find.byWidgetPredicate(
        (Widget widget) => widget.toString().contains(subjectString),
      );
      expect(subjectFinder, findsOneWidget);

      int noteContentMaxCharacters = 60;
      final subjectWidget = tester.widget<RichText>(subjectFinder);
      final subjectText = subjectWidget.text.toPlainText();
      String noteContentTrimmed = record.notes!
          .trim()
          .replaceAll("\n                              ", "\n");
      String noteContentSpaced =
          noteContentTrimmed.trim().replaceAll(RegExp(r'\s+'), ' ');
      String noteContent = noteContentSpaced.trim().replaceAll("; ", ":\n");
      String noteContentString = noteContent.length > noteContentMaxCharacters
                        ? '${noteContent.substring(0, noteContentMaxCharacters)}...\n\n'
                        : '${noteContent}\n\n';
      expect(subjectText.contains(noteContentString), isTrue);

      final viewFullNoteFinder = find.byKey(Key('viewFullNoteId-${record.id}'));
      expect(viewFullNoteFinder, findsOneWidget);
    });

    String viewNoteString = 'View Full Note';
    Finder viewnoteFinder = find.byWidgetPredicate(
      (Widget widget) => widget.toString().contains(viewNoteString),
    );
    expect(viewnoteFinder, findsNWidgets(notesModel.records!.length));

    final forwardIconFinder = find.byIcon(Icons.arrow_forward);
    expect(forwardIconFinder, findsNWidgets(notesModel.records!.length));
  });
}