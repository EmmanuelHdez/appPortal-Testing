import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/presentation/appViews/navigation_bar/bloc/navigation_bar_bloc.dart';
import 'package:src/presentation/appViews/navigation_bar/main_screen.dart';
import 'package:src/presentation/widgets/custom_list_title.dart';
import 'package:src/shared/user_preferences.dart';
import 'package:src/utils/app_export.dart';
import 'webView.dart';

class OnboardingWidget extends StatefulWidget {
  final List<NotificationsModel> notificationsModel;
  final String patientName;
  const OnboardingWidget(
      {Key? key, required this.notificationsModel, required this.patientName})
      : super(key: key);

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState(
        this.notificationsModel,
        this.patientName,
      );
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  final List<NotificationsModel> notificationsModel;
  final String patientName;
  final UserPreferences userInfo = UserPreferences();
  late List<Map<String, dynamic>> myCardData;
  late NotificationsModel nextAppointment;
  late String formatName;
  bool isPopupOpen = false;

  _OnboardingWidgetState(this.notificationsModel, this.patientName);

  NotificationsModel? findComponent(
      List<NotificationsModel> dataList, String name) {
    return dataList.where((element) => element.component == name).firstOrNull;
  }

  String _formatDate(String? dateString) {
    if (dateString == null) {
      return "Date not available";
    }
    DateTime date = DateTime.parse(dateString);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()}";
  }

  String _formatDoctorName() {
    if (nextAppointment.doctor == null) {
      return "";
    }
    return " with Dr ${nextAppointment.doctor?.firstName} ${nextAppointment.doctor?.lastName}";
  }

  void _showPopup() {
    if (!isPopupOpen) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Access the Medqare Portal"),
            content: const Text(
                "To read your notes, you must access the Medqare Portal."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Set isPopupOpen to false when the pop-up is closed
                  setState(() {
                    isPopupOpen = false;
                  });
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
      // Set isPopupOpen to true when the pop-up is opened
      setState(() {
        isPopupOpen = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      nextAppointment = findComponent(notificationsModel, 'nextAppointment')!;
    });
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
                    builder: (context) => const MainScreen(
                          index: 3,
                        )),
              );
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
                  builder: (context) => const MainScreen(
                        index: 3,
                      )),
            );
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

  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    Widget imgHeaderWidget;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      imgHeaderWidget = _buildImgHeaderPortrait();
    } else {
      imgHeaderWidget = _buildImgHeaderLandScape();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  imgHeaderWidget,
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      "Hi there, $patientName 👋",
                      style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2A3786)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Text Date
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text.rich(
                        nextAppointment.startTime != null
                            ? TextSpan(
                                text: "Your next appointment is on ",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF2A3786),
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        _formatDate(nextAppointment.startTime),
                                    style: const TextStyle(
                                      color: Color(0xFF6048DE),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _formatDoctorName(),
                                    style: const TextStyle(
                                      color: Color(0xFF2A3786),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              )
                            : const TextSpan(
                                text:
                                    "You do not have any upcoming appointments booked.",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF2A3786),
                                )),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          height: 1.5,
                        )),
                  ),

                  //Notification Card
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: const EdgeInsets.only(top: 27.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A3786)),
                          ),
                        ),
                        const SizedBox(height: 18.0),
                        BlocBuilder<NavigationBarBloc, NavigationBarState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainScreen(
                                                    index: 1,
                                                  )));
                                    },
                                    child: CustomListTitle(
                                      iconData:
                                          'assets/images/app_icons/Appointments.png',
                                      text: "Appointments",
                                      notificationCount:
                                          state.appointmentsCounter,
                                      iconSize: 23,
                                    )),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainScreen(
                                                    index: 2,
                                                  )));
                                    },
                                    child: CustomListTitle(
                                      iconData:
                                          'assets/images/app_icons/Forms.png',
                                      text: "Your Forms",
                                      notificationCount: state.formsCounter,
                                      iconSize: 23,
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainScreen(
                                                  index: 4,
                                                )));
                                  },
                                  child: CustomListTitle(
                                    iconData:
                                        'assets/images/app_icons/Unread-notes.png',
                                    text: "Unread Portal Notes",
                                    notificationCount: state.notesCounter,
                                    iconSize: 23,
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Button

                  // Unified Change

                  Container(
                    margin: const EdgeInsets.only(top: 18.0, bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        String token = await userInfo.getToken();
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewContainer(
                              url:
                                  "${EnvironmentConfig.portalUrl}/auth/success",
                              token: token,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        side: const BorderSide(color: Color(0xFF2A3786)),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        fixedSize: const Size.fromWidth(260.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Expanded(
                              child: Text(
                            'Access your MedQare Portal',
                            style: TextStyle(
                              color: Color(0xFF2A3786),
                              fontSize: 14,
                            ),
                          )),
                          const SizedBox(width: 8.0),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF6048DE),
                            ),
                            child: const Icon(Icons.arrow_forward,
                                color: Colors.white, size: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
