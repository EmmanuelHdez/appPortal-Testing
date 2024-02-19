import 'package:flutter/material.dart';
import 'package:src/presentation/appViews/navigation_bar/main_screen.dart';
import 'package:src/presentation/routes/settings_router.dart';
import 'package:src/presentation/widgets/custom_list_title.dart';
import 'package:src/utils/app_export.dart';
import 'package:intl/intl.dart';
import 'package:src/data/model/appointments_model.dart';
import 'package:src/data/model/appointment_info_model.dart';

class AppointmentsDetailsWidget extends StatefulWidget {
  final AppointmentInfoModel appointmentDetailsModel;
  final dynamic futureAppointments;
  final bool notificationTap;
  const AppointmentsDetailsWidget(
      {Key? key,
      required this.appointmentDetailsModel,
      required this.futureAppointments,
      this.notificationTap = false})
      : super(key: key);

  @override
  State<AppointmentsDetailsWidget> createState() =>
      _AppointmentsDetailsWidgetState(
          this.appointmentDetailsModel, this.futureAppointments);
}

class _AppointmentsDetailsWidgetState extends State<AppointmentsDetailsWidget> {
  final AppointmentInfoModel appointmentDetailsModel;
  final dynamic futureAppointments;
  List<dynamic> sortedAppointmentRecords = [];

  _AppointmentsDetailsWidgetState(
      this.appointmentDetailsModel, this.futureAppointments);
  @override
  void initState() {
    super.initState();
    sortAppointments();
  }

  sortAppointments() {
    List<AppointmentModel>? allUpcomingAppointments =
        futureAppointments.records;

    if (futureAppointments.records!.isNotEmpty) {
      allUpcomingAppointments
          ?.sort((a, b) => a.startTime!.compareTo(b.startTime!));
      setState(() {
        sortedAppointmentRecords = allUpcomingAppointments!;
      });
    } else {
      setState(() {
        sortedAppointmentRecords = futureAppointments.records!;
      });
    }
  }

  String getDifferenceTime(DateTime startTime, DateTime endTime) {
    Duration difference = endTime.difference(startTime);

    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;

    List<String> parts = [];

    if (hours > 0) {
      parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
    }

    if (minutes > 0) {
      parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
    }

    if (parts.isEmpty) {
      return '0 minutes';
    }

    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate(String dateString) {
      DateTime dateTime = DateTime.parse(dateString);
      String dateFormattedString = DateFormat('dd/MM/yyyy').format(dateTime);

      return dateFormattedString;
    }

    Widget buildNextAppointmentText(dynamic futureAppointments) {
      String doctorFullName = '';

      if (futureAppointments != null && futureAppointments.length > 0) {
        var appointment = futureAppointments[0];
        if (appointment.doctor != null) {
          doctorFullName =
              '${appointment.doctor.firstName} ${appointment.doctor.lastName}';
        }
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Text.rich(
            futureAppointments != null && futureAppointments.length > 0
                ? TextSpan(
                    text: "Your next appointment is on ",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF2A3786),
                    ),
                    children: [
                      TextSpan(
                        text: formattedDate(futureAppointments[0].startTime),
                        style: const TextStyle(
                          color: Color(0xFF6048DE),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' with Dr ',
                        style: const TextStyle(
                          color: Color(0xFF2A3786),
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: doctorFullName,
                            style: const TextStyle(
                              color: Color(0xFF2A3786),
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const TextSpan(
                    text: "You do not have any upcoming appointments booked.",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF2A3786)),
                  ),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(
              height: 1.5,
            )),
      );
    }

    Widget buildAppointmentDetailsWidget(dynamic appointmentInfo) {
      return SingleChildScrollView(
        child: Column(children: [
          DetailCard(
            iconData: 'assets/images/app_icons/date_icon.png',
            label: 'Date',
            textValue: DateFormat('dd/MM/yyyy HH:mm:ss')
                .format(appointmentInfo.startTime),
          ),
          DetailCard(
            iconData: 'assets/images/app_icons/duration_icon.png',
            label: 'Duration',
            textValue: getDifferenceTime(
                appointmentInfo.startTime, appointmentInfo.endTime),
          ),
          DetailCard(
              iconData: 'assets/images/app_icons/where_icon.png',
              label: 'Where',
              textValue: appointmentInfo.patientLink != null
                  ? appointmentInfo.patientLink.toString()
                  : "No Url"),
          DetailCard(
            iconData: 'assets/images/app_icons/doctor_icon.png',
            label: 'Doctor',
            textValue:
                'Dr. ${appointmentInfo.doctor.firstName} ${appointmentInfo.doctor.lastName}',
          ),
          DetailCard(
            iconData: 'assets/images/app_icons/treatment_type_icon.png',
            label: 'Treatment',
            textValue: appointmentInfo.treatment.name,
          ),
        ]),
      );
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
                size: 32.0,
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
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 20),
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
                                          const MainScreen(index: 1)));
                            } else {
                              Navigator.pushNamed(
                                  context, AppRoutes.settingsPage);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: const Color(0xFF2A3786),
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
                            'Appointments',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A3786)),
                          ),
                        )),
                  ],
                ),
              ),
              buildNextAppointmentText(sortedAppointmentRecords),
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.only(top: 27.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomListTitle(
                        iconData: 'assets/images/app_icons/Appointments.png',
                        text: 'Upcoming Appointments',
                        notificationCount: sortedAppointmentRecords.length,
                      ),
                      const SizedBox(height: 15.0),
                      buildAppointmentDetailsWidget(appointmentDetailsModel),
                    ],
                  )),
            ])),
      ),
    ));
  }
}

class DetailCard extends StatelessWidget {
  final String iconData;
  final String label;
  final String textValue;
  final double iconSize;

  const DetailCard({
    Key? key,
    required this.iconData,
    required this.label,
    required this.textValue,
    this.iconSize = 23.0,
  }) : super(key: key);

  Widget buildMeetingUrl(dynamic url, dynamic context) {
    if (url != 'No Url') {
      return Expanded(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2A3786),
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const TextSpan(
                text:
                    ' The appointment will be online. The link can be found on the portal, in your notes, or sent to you by e-mail.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2A3786),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2A3786),
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const TextSpan(
                text: 'You will be sent a link to join your appointment online',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    double fSize = 14;
    return Container(
      margin: const EdgeInsets.only(top: 0.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Image(
                    image: AssetImage(iconData),
                    width: 22,
                  ),
                ),
                const SizedBox(width: 14.0),
                label != 'Where'
                    ? Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: fSize,
                              color: const Color(0xFF2A3786),
                              fontWeight: FontWeight.normal,
                            ),
                            children: [
                              TextSpan(
                                text: '$label: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fSize,
                                ),
                              ),
                              TextSpan(
                                  text: ' $textValue',
                                  style: TextStyle(fontSize: fSize)),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: Row(
                          children: [
                            buildMeetingUrl(textValue, context),
                          ],
                        ),
                      ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: const Divider(
                color: Color(0xFF2A3786),
                thickness: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
