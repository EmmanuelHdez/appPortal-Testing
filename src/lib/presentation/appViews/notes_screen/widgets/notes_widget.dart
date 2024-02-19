import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/data/model/notes_model.dart';
import 'package:src/presentation/appViews/notes_screen/bloc/notes_bloc.dart';
import 'package:src/presentation/routes/settings_router.dart';
import 'package:src/presentation/widgets/custom_list_title.dart';
import 'package:src/utils/app_export.dart';
import 'package:intl/intl.dart';
import '../../navigation_bar/bloc/navigation_bar_bloc.dart';

class NotesWidget extends StatefulWidget {
  final NotesModel notesModel;
  final String patientName;
  const NotesWidget(
      {Key? key, required this.notesModel, required this.patientName})
      : super(key: key);

  @override
  State<NotesWidget> createState() =>
      _NotesWidgetState(this.notesModel, this.patientName);
}

class _NotesWidgetState extends State<NotesWidget> {
  final NotesModel notesModel;
  final String patientName;
  late List<Map<String, dynamic>> notificationsList;
  late List<Map<String, dynamic>> dataList;

  _NotesWidgetState(this.notesModel, this.patientName);
  @override
  void initState() {
    super.initState();
  }

  Widget buildUnreadNotesMessageWidget(
      dynamic unreadNotesList, int? unreadNotesTotal) {
    if (unreadNotesTotal != null && unreadNotesTotal > 0) {
      return Container(
         padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child:  Text.rich(
           textAlign: TextAlign.center,
           maxLines: 3,
            style: const TextStyle(
            height: 1.5,
          ),
              TextSpan(
                text: "You currently have ",
                style: const TextStyle(
                  color: Color(0xFF2A3786),
                  fontSize: 15,
                ),
                children: [
                  TextSpan(
                    text: unreadNotesTotal == 1
                        ? '$unreadNotesTotal unread portal note.'
                        : '$unreadNotesTotal unread portal notes.',
                    style: const TextStyle(
                      color: Color(0xFF6048DE),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                                TextSpan(
                text:
                    'View and respond to ${unreadNotesTotal == 1 ? 'it' : 'them'} below.',
                style: const TextStyle(
                  color: Color(0xFF2A3786),
                  fontSize: 15,
                ))
                ],
              ),
            ),
      );
    } else {
      return  Container(
         padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: const Text(
          'You do not have any unread notes.',
          style: TextStyle(
            color: Color(0xFF2A3786),
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _buildImgHeaderPortrait(contex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomImageView(
              imagePath: ImageConstant.imgHeader, width: size.width * 1.0),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsRouter()));
            },
            child: const Icon(
              Icons.settings,
              color: Color(0xFFd1d5db),
              size: 36.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImgHeaderLandScape(contex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgHeader,
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width < 600
                  ? null // Phone vertical orientation portrait
                  : null // Tablet vertical orientation portrait
              : MediaQuery.of(context).size.width < 1000
                  ? getHorizontalSize(
                      size.width * 0.85) // Phone landscape orientation
                  : getHorizontalSize(350), // Tablet landscape orientation
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsRouter()));
          },
          child: const Icon(
            Icons.settings,
            color: Color(0xFFd1d5db),
            size: 36.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double normalText = SizeUtils.calculateHomeNormalTextFontSize(context);
    mediaQueryData = MediaQuery.of(context);
    Widget imgHeaderWidget;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      imgHeaderWidget = _buildImgHeaderPortrait(context);
    } else {
      imgHeaderWidget = _buildImgHeaderLandScape(context);
    }
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(
              left: 36,
              top: 20,
              right: 36,
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              imgHeaderWidget,
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "Hi, ${patientName} 👋",
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700, // Semibold
                      color: Color(0xFF2A3786)),
                  textAlign: TextAlign.center,
                ),
              ),
              buildUnreadNotesMessageWidget(
                  notesModel.records, notesModel.total),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(top: 27.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Portal Notes",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2A3786),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    BlocBuilder<NavigationBarBloc, NavigationBarState>(
                      builder: (context, state) {
                        return CustomListTitle(
                            iconData:
                                'assets/images/app_icons/Unread-notes.png',
                            text: 'Unread portal notes',
                            notificationCount: state.notesCounter,
                            iconSize: 23);
                      },
                    ),
                    notesModel.records!.length > 0
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * .43,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: notesModel.records!.length,
                              itemBuilder: (context, index) {
                                final noteInfo = notesModel.records![index];
                                return NoteInfoWidget(
                                  noteData: noteInfo,
                                );
                              },
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(bottom: 15, top: 5),
                            height: 18.0,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                'You do not have any unread notes.',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey),
                              ),
                            )),
                  ],
                ),
              ),
            ])),
      ),
    ));
  }
}

class CustomCardWidget extends StatelessWidget {
  final dynamic iconData;
  final String text;
  final int notificationCount;
  final double iconSize;
  const CustomCardWidget(
      {super.key,
      required this.iconData,
      required this.text,
      required this.notificationCount,
      required this.iconSize});

  @override
  Widget build(BuildContext context) {
    double iconSize = SizeUtils.calculateIconSize(context);
    double normalText = SizeUtils.calculateHomeNormalTextFontSize(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: const Color(0xFFF1F5F9),
      child: Padding(
          padding: const EdgeInsets.only(top: 2.0, bottom: 2),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 4),
                child: Image(image: AssetImage(iconData), width: iconSize),
              ),
            ),
            Container(
              padding: MediaQuery.of(context).size.width < 600
                  ? const EdgeInsets.only(top: 2, bottom: 1)
                  : const EdgeInsets.only(top: 2, bottom: 3),
              child: Text(
                notificationCount.toString(),
                style: TextStyle(
                  color: const Color(0xFF2A3786),
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height < 800 ? 12 : 15,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height < 800
                              ? normalText - 2.5
                              : normalText - 1
                          : normalText - 1,
                  color: const Color(0xFF94a3b8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ))
          ])),
    );
  }
}

class NoteInfoWidget extends StatelessWidget {
  String formatDateNote(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);

    String day = DateFormat('d').format(dateTime);
    String month = DateFormat('MMMM').format(dateTime);
    String year = DateFormat('y').format(dateTime);
    String time = DateFormat('jm').format(dateTime);

    String daySuffix = _getDaySuffix(int.parse(day));

    return '$day$daySuffix $month $year, $time';
  }

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

  final NoteModel noteData;

  NoteInfoWidget({required this.noteData});

  _markNoteAsSeen(BuildContext context, NoteModel noteData) {
    try {
      if (noteData.id != null) {
        context.read<NotesBloc>().add(MarkNoteAsSeen(noteData.id, noteData));
      }
    } catch (e) {
      print('Error when obtaining the form token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String noteContentTrimmed = noteData.notes!
        .trim()
        .replaceAll("\n                              ", "\n");
    String noteContentSpaced =
        noteContentTrimmed.trim().replaceAll(RegExp(r'\s+'), ' ');
    String noteContent = noteContentSpaced.trim().replaceAll("; ", ":\n");

    if (noteData.formCollections!.length > 0) {
      dynamic collection = noteData.formCollections?[0];
      if (json.decode(collection['formURLs']).length > 1) {
        noteContent =
            'The following forms have been sent, please complete them.\n';
      } else {
        noteContent =
            'The following forms have been sent, please complete it.\n';
      }
      json.decode(noteData.formCollections?[0]['formURLs']).forEach((form) {
        noteContent =
            '$noteContent\n${formHasFormCounter(collection, form)} - ${form['percentageCompletion']}%';
      });
    }

    int noteContentMaxCharacters = 60;

    String writtenByText =
        'Written By ${noteData?.addedBy!.firstName} ${noteData?.addedBy!.lastName}';
    if (noteData?.addedBy!.jobTitle != null)
      writtenByText = '$writtenByText, ${noteData?.addedBy!.jobTitle}';
    if (noteData?.addedBy!.department != null)
      writtenByText = '$writtenByText, ${noteData?.addedBy!.department}';

    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14.0,
                color: Color(0xFF2A3786),
              ),
              children: [
                TextSpan(
                  text: '${writtenByText}\n',
                  style: const TextStyle(
                    color: Color(0xFF2A3786),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Text(''),
                  ),
                ),
                TextSpan(
                    text: 'Subject: ${noteData.noteSubject}\n',
                    style: const TextStyle(
                      color: Color(0xFF2A3786),
                      fontSize: 14,
                      height: 1.4,
                    )),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Text(''),
                  ),
                ),
                TextSpan(
                  text: '${formatDateNote(noteData.created.toString())} \n',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A3786),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Text(''),
                  ),
                ),
                TextSpan(
                    text: noteContent.length > noteContentMaxCharacters
                        ? '${noteContent.substring(0, noteContentMaxCharacters)}...\n\n'
                        : '${noteContent}\n\n',
                    style: const TextStyle(
                      color: Color(0xFF2A3786),
                      fontSize: 14,
                      height: 1.4,
                    )),
                WidgetSpan(
                  child: GestureDetector(
                    key: Key('viewFullNoteId-${noteData.id}'),
                    onTap: () => _markNoteAsSeen(context, noteData),
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "View Full Note",
                            style: TextStyle(
                              color: Color(0xFF6048DE),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Color(0xFF6048DE),
                                size: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Divider(height: 0),
        ),
      ),
    ]);
  }
}
