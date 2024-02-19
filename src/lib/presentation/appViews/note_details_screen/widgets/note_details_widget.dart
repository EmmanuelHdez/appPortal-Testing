import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/notes_model.dart';
import 'package:src/presentation/appViews/home_screen/webView.dart';
import 'package:src/presentation/appViews/logout_screen.dart';
import 'package:src/presentation/appViews/navigation_bar/main_screen.dart';
import 'package:src/presentation/appViews/notes_screen/bloc/notes_bloc.dart';
import 'package:src/presentation/routes/settings_router.dart';
import 'package:src/presentation/shared/loading_widget.dart';
import 'package:src/shared/shared_preferences.dart';
import 'package:src/utils/app_export.dart';
import 'package:intl/intl.dart';

class NoteDetailsWidget extends StatefulWidget {
  final NoteModel? noteData;
  final bool notificationTap;
  const NoteDetailsWidget({
    Key? key,
    required this.noteData,
    this.notificationTap = false,
  }) : super(key: key);

  @override
  State<NoteDetailsWidget> createState() =>
      _NoteDetailsWidgetState(this.noteData);
}

class _NoteDetailsWidgetState extends State<NoteDetailsWidget> {
  final NoteModel? noteData;
  TextEditingController _noteTextController = new TextEditingController();
  _NoteDetailsWidgetState(this.noteData);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _noteTextController.dispose();
    super.dispose();
  }

  String getAppointmentType(dynamic appointmentData) {
    String appointmentType = '';

    if (appointmentData.followUp) appointmentType = 'Follow Up';
    if (appointmentData.f2F) appointmentType = 'F2F';
    if (appointmentData.f2Ffollowup) appointmentType = 'F2F Follow Up';
    if (appointmentData.existingFollowup)
      appointmentType = 'Existing Follow Up';

    return appointmentType;
  }

  @override
  Widget build(BuildContext context) {
    double normalText = SizeUtils.calculateHomeNormalTextFontSize(context);
    dynamic noteTextContentTrimmed = noteData!.notes!
        .trim()
        .replaceAll("\n                              ", "\n");
    dynamic noteTextContentSpaced =
        noteTextContentTrimmed.trim().replaceAll(RegExp(r'\s+'), ' ');
    dynamic noteTextContent =
        noteTextContentSpaced.trim().replaceAll("; ", ":\n");

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

    Widget _buildImgHeaderPortrait() {
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

    Widget _buildImgHeaderLandScape() {
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

    mediaQueryData = MediaQuery.of(context);
    Widget imgHeaderWidget;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      imgHeaderWidget = _buildImgHeaderPortrait();
    } else {
      imgHeaderWidget = _buildImgHeaderLandScape();
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _createNote(BuildContext context, int? noteId) async {
      String? noteBody = _noteTextController.text;
      try {
        if (noteBody != '' && noteId != null) {
          context.read<NotesBloc>().add(CreateNote(noteId, noteBody));
        }
      } catch (e) {
        print('Error when creating a note: $e');
      }
    }

    // ignore: no_leading_underscores_for_local_identifiers
    void _showErrorModal(String message, BuildContext context) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: message,
      );
    }

    void _openWebViewForm(
        BuildContext context, String token, Map<String, dynamic> form) {
      String formUrl = form["locked"] == 1
          ? form["formViewURL"] ??
              form["formURL"].replaceFirst('renderform', 'displayresult')
          : form["formEditURL"] ?? form["formURL"];
      formUrl = "$formUrl?jwt=$token";
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewContainer(
              url: formUrl,
            ),
          ),
        );
      });
    }

    String writtenByText =
        'Written By ${noteData?.addedBy!.firstName} ${noteData?.addedBy!.lastName}';
    if (noteData?.addedBy!.jobTitle != null)
      writtenByText = '$writtenByText, ${noteData?.addedBy!.jobTitle}';
    if (noteData?.addedBy!.department != null)
      writtenByText = '$writtenByText, ${noteData?.addedBy!.department}';

    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is NotesDetailsLoading) {
          const LoadingWidget();
        } else if (state is NoteCreated) {
          Navigator.pushNamed(context, AppRoutes.settingsPage);
          MotionToast.success(
            title: const Text(
              'Success',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            description: const Text("Note Created!"),
            animationType: AnimationType.fromTop,
            position: MotionToastPosition.bottom,
            animationDuration: const Duration(seconds: 15),
          ).show(context);
        } else if (state is FormTokenReceived) {
          _openWebViewForm(context, state.result.token, state.form);
        } else if (state is NotesError) {
          if (state.message == 401 || state.message == '401') {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LogoutScreen()),
                (Route<dynamic> route) => false,
              );
            });
          } else {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              _showErrorModal('Sorry, something went wrong', context);
            });
          }
        }
      },
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          return SafeArea(
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
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
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                imgHeaderWidget,
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (widget.notificationTap) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MainScreen(
                                                              index: 4,
                                                            )));
                                              } else {
                                                Navigator.pushNamed(context,
                                                    AppRoutes.notesPage);
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(7.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF2A3786),
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color: Color(0xFF2A3786),
                                                size: 18.0,
                                              ),
                                            ),
                                          )),
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: const Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              'Portal Notes',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2A3786)),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: mediaQueryData.size.height * 0.62,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                margin: const EdgeInsets.only(
                                                    top: 10.0, bottom: 10.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color:
                                                      const Color(0x80bfdbfe),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 16,
                                                      horizontal: 16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                          text: TextSpan(
                                                              children: [
                                                            TextSpan(
                                                              text:
                                                                  '${writtenByText}\n',
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xFF2A3786),
                                                                fontSize: 14,
                                                                height: 1.4,
                                                              ),
                                                            ),
                                                          ])),
                                                      RichText(
                                                          text: TextSpan(
                                                              children: [
                                                            TextSpan(
                                                              text:
                                                                  'Subject: ${noteData?.noteSubject}\n',
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xFF2A3786),
                                                                fontSize: 14,
                                                                height: 1.4,
                                                              ),
                                                            ),
                                                          ])),
                                                      RichText(
                                                        text: TextSpan(
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF2A3786),
                                                            fontSize: 14,
                                                            height: 1.4,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  '${formatDateNote(noteData!.created.toString())}\n',
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xFF2A3786),
                                                                  fontSize: 14,
                                                                  height: 1.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const WidgetSpan(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            4.0),
                                                                child: Text(''),
                                                              ),
                                                            ),
                                                            if (noteData!
                                                                    .task?.id !=
                                                                null)
                                                              TextSpan(
                                                                  text:
                                                                      'TASK ID: ${noteData!.task?.id}\n',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color(
                                                                        0xFF2A3786),
                                                                    height: 1.4,
                                                                    fontSize:
                                                                        14,
                                                                  )),
                                                          ],
                                                        ),
                                                      ),
                                                      noteData?.noteSubject ==
                                                              'appointmentNote'
                                                          ? _appointmentNote(
                                                              noteTextContent,
                                                              normalText)
                                                          : noteData!
                                                                  .noteSubject!
                                                                  .contains(
                                                                      'Booking Link Sent')
                                                              ? _bookingLinkNote(
                                                                  noteTextContent,
                                                                  noteData!
                                                                      .notesHtml,
                                                                  noteData!
                                                                      .notesJson,
                                                                  normalText,
                                                                  context)
                                                              : noteData!.formCollections !=
                                                                          null &&
                                                                      noteData!
                                                                              .formCollections!
                                                                              .length >
                                                                          0
                                                                  ? _showForms(
                                                                      context,
                                                                      noteData
                                                                          ?.formCollections,
                                                                      normalText)
                                                                  : RichText(
                                                                      text: TextSpan(
                                                                          children: [
                                                                          TextSpan(
                                                                              text: '$noteTextContent',
                                                                              style: const TextStyle(
                                                                                color: Color(0xFF2A3786),
                                                                                height: 1.4,
                                                                                fontSize: 14,
                                                                              )),
                                                                        ])),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          noteData!.patientCanRespond == true
                                              ? Container(
                                                  key:
                                                      const Key('noteKeyboard'),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color:
                                                        const Color(0x80bfdbfe),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16,
                                                        horizontal: 16),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              border:
                                                                  Border.all(
                                                                color: const Color(
                                                                    0xFF2A3786),
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: const Icon(
                                                              Icons.add,
                                                              color: Color(
                                                                  0xFF2A3786),
                                                              size: 28.0,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          0.0),
                                                              height: 32.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: TextField(
                                                                controller:
                                                                    _noteTextController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                onChanged:
                                                                    (value) {
                                                                  context
                                                                      .read<
                                                                          NotesBloc>()
                                                                      .add(GetNoteText(
                                                                          noteBody:
                                                                              value));
                                                                },
                                                                decoration:
                                                                    const InputDecoration(
                                                                  hintText:
                                                                      'Type your reply here...',
                                                                  contentPadding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          18.0),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0xFF2A3786),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            key: const Key(
                                                                'sendNoteReplyBtn'),
                                                            onTap: () =>
                                                                _createNote(
                                                                    context,
                                                                    noteData!
                                                                        .id),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Color(
                                                                    0xFF6048DE),
                                                              ),
                                                              child: const Icon(
                                                                Icons
                                                                    .arrow_forward,
                                                                color: Colors
                                                                    .white,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          )
                                                        ]),
                                                  ),
                                                )
                                              : const SizedBox()
                                        ])),
                              ])),
                    ),
                  )));
        },
      ),
    );
  }
}

Widget _appointmentNote(dynamic noteTextContent, dynamic sizeText) {
  RegExp regExp = RegExp("Appointment link: [^\n]*\n");
  // Delete the property and content of 'Appointment link'.
  String newText = noteTextContent.replaceAll(regExp, "");
  // Find link matches
  dynamic matchLink = linkRegExp.firstMatch(noteTextContent);
  dynamic uriLink;
  if (matchLink != null) {
    uriLink = Uri.parse(matchLink?.group(0));
  }
  dynamic matchStatus = RegExp("Status:([^:]+)").firstMatch(newText);
  String? statusAppoinmentNote = '';

  if (matchStatus != null) {
    // Get appointment status
    statusAppoinmentNote = matchStatus?.group(1)?.trim();
  }
  return RichText(
      text: TextSpan(children: [
    TextSpan(
        text: '${newText}',
        style: TextStyle(
          color: Color(0xFF2A3786),
          fontSize: sizeText,
        )),
    if (statusAppoinmentNote!.contains('Accepted'))
      const TextSpan(
          text:
              '\n\nPlease log on to the portal to access the appointment link.',
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.grey)),
    if (statusAppoinmentNote.contains('Provisional'))
      TextSpan(
          text: '\nPending Approval',
          style: TextStyle(
            color: Color(0xFF2A3786),
            fontSize: sizeText,
          ))
  ]));
}

Widget _bookingLinkNote(dynamic noteTextContent, String? notesHTML,
    String notesJSON, dynamic sizeText, BuildContext context) {
  List<dynamic> parsedJson = json.decode(notesJSON);
  final uriLink = Uri.parse(parsedJson[2]["attributes"]["link"]);
  final noteText = '${parsedJson[0]["insert"]}${parsedJson[1]["insert"]}';
  return RichText(
      text: TextSpan(children: [
    TextSpan(
        text: '$noteText',
        style: TextStyle(
          color: Color(0xFF2A3786),
          fontSize: sizeText,
        )),
    if (uriLink != null)
      TextSpan(
          mouseCursor: SystemMouseCursors.click,
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewContainer(
                    url: uriLink.toString(),
                  ),
                ),
              );
            }, // TextSpan(
          text: '\nClick here to book your appointment\n',
          style: TextStyle(
              fontSize: sizeText,
              color: Color(0xFF6048DE),
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline)),
    TextSpan(
        text: '\nThank you.',
        style: TextStyle(
          fontSize: sizeText,
          color: Color(0xFF2A3786),
        )),
  ]));
}

Widget _showForms(
    BuildContext context, List<dynamic>? formCollections, dynamic sizeText) {
  List<Map<String, dynamic>> forms = [];
  if (formCollections != null && formCollections.length > 0) {
    for (var element in formCollections!) {
      final formURLs = json.decode(element['formURLs']);
      formURLs.forEach((f) {
        forms.add(f);
      });
    }
  }

  void _getFormToken(BuildContext context, Map<String, dynamic> form,
      Map<String, dynamic> collection) async {
    int userId = await MySharedPreferences.instance.getIntValue(USER_ID);
    int? collectionId = collection['id'];
    int? patientId = collection['patient'];
    bool isDoctor = false;
    try {
      if (collectionId != null && patientId != null) {
        context.read<NotesBloc>().add(
            RequestFormToken(collectionId, patientId, userId, isDoctor, form));
      }
    } catch (e) {
      print('Error when obtaining the form token: $e');
    }
  }

  return RichText(
      text: TextSpan(children: [
    TextSpan(
        text: forms.length == 1
            ? 'The following form has been sent, please complete it.\n'
            : 'The following forms have been sent, please complete them.\n',
        style: const TextStyle(
          color: Color(0xFF2A3786),
          height: 1.4,
          fontSize: 14,
        )),
    for (var collection in formCollections!)
      for (var form in json.decode(collection['formURLs']))
        TextSpan(
            mouseCursor: SystemMouseCursors.click,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                _getFormToken(context, form, collection);
              },
            text:
                '\n${formHasFormCounter(collection, form)} - ${form['percentageCompletion']}%',
            style: const TextStyle(
              color: Color(0xFF6048DE),
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.4,
            )),
  ]));
}
