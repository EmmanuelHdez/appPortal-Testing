import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/data/model/appointments_model.dart';
import 'package:src/data/model/past_appointments_model.dart';
import 'package:src/presentation/routes/settings_router.dart';
import 'package:src/presentation/widgets/custom_list_title.dart';
import 'package:src/utils/app_export.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../navigation_bar/bloc/navigation_bar_bloc.dart';

class AppointmentsWidget extends StatefulWidget {
  final String patientName;
  final AppointmentsModel futureAppointmentsModel;
  final PastAppointmentsModel pastAppointmentsModel;
  AppointmentsWidget({
    Key? key,
    required this.patientName,
    required this.futureAppointmentsModel,
    required this.pastAppointmentsModel,
  }) : super(key: key);

  @override
  _AppointmentsWidgetState createState() => _AppointmentsWidgetState(
      this.futureAppointmentsModel,
      this.pastAppointmentsModel,
      this.patientName);
}

class _AppointmentsWidgetState extends State<AppointmentsWidget> {
  final AppointmentsModel futureAppointmentsModel;
  final PastAppointmentsModel pastAppointmentsModel;
  final String patientName;
  late MediaQueryData mediaQueryData;

  bool loading = true;
  List<dynamic> sortedAppointmentRecords = [];
  int totalUpcomingAppointments = 0;
  String nextAppointmentInfo =
      'You do not have any upcoming appointments booked.';
  List<dynamic> appointmentsSorted = [];

  _AppointmentsWidgetState(this.futureAppointmentsModel,
      this.pastAppointmentsModel, this.patientName);

  void updateStateCounter({required int newAppointmentsCounter}) {
    setState(() {
      totalUpcomingAppointments = newAppointmentsCounter;
    });
  }

  @override
  void initState() {
    super.initState();
    totalUpcomingAppointments = futureAppointmentsModel.total!;
    sortAppointments();
  }

  sortAppointments() {
    List<AppointmentModel>? allUpcomingAppointments =
        futureAppointmentsModel.records;

    if (futureAppointmentsModel.records!.isNotEmpty) {
      allUpcomingAppointments
          ?.sort((a, b) => a.startTime!.compareTo(b.startTime!));
      setState(() {
        sortedAppointmentRecords = allUpcomingAppointments!;
      });
    } else {
      setState(() {
        sortedAppointmentRecords = futureAppointmentsModel.records!;
      });
    }
  }

  String formattedDate(String? inputDate) {
    if (inputDate != null) {
      final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ");
      final inputDateTime = inputFormat.parse(inputDate);

      final outputFormat = DateFormat("dd/MM/yyyy");
      final formatted = outputFormat.format(inputDateTime);

      return formatted;
    }
    return 'Invalid date';
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

  String getActualStatus(dynamic actualEndTime) {
    String actualStatus = '';
    actualStatus = actualEndTime != null ? 'Attended' : 'Not Attended';

    return actualStatus;
  }

  Widget buildAppointmentWidget(dynamic futureAppointments) {
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

  @override
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
                buildAppointmentWidget(sortedAppointmentRecords),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.only(top: 27.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Appointments',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A3786)),
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      BlocBuilder<NavigationBarBloc, NavigationBarState>(
                        builder: (context, state) {
                          return CustomListTitle(
                              iconData:
                                  'assets/images/app_icons/Appointments.png',
                              text: 'Upcoming Appointments',
                              notificationCount: state.appointmentsCounter);
                        },
                      ),
                      futureAppointmentsModel.total! > 0
                          ? Column(
                              children: [
                                const SizedBox(height: 5.0),
                                SizedBox(
                                  height: MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? mediaQueryData.size.height * 0.14
                                      : mediaQueryData.size.height * 0.25,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount:
                                        futureAppointmentsModel.records!.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                    itemBuilder: (context, index) {
                                      final appointment =
                                          futureAppointmentsModel
                                              .records?[index];
                                      // Extract relevant data from the appointment
                                      return AppointmentItem(
                                        id: appointment!.id,
                                        type: getAppointmentType(appointment),
                                        date: formattedDate(
                                            appointment.startTime),
                                        status: 'hide',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              margin: const EdgeInsets.only(bottom: 15, top: 5),
                              height: 18.0,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'You do not have any upcoming appointments booked.',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey),
                                ),
                              )),
                      const CustomListTitle(
                        iconData:
                            'assets/images/app_icons/Past-Appointments.png',
                        text: 'Past Appointments',
                        notificationCount: null,
                      ),
                      const SizedBox(height: 8.0),
                      pastAppointmentsModel.total != 0
                          ? SizedBox(
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? mediaQueryData.size.height * 0.28
                                  : mediaQueryData.size.height * 0.25,
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount:
                                    pastAppointmentsModel.records!.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                                itemBuilder: (context, index) {
                                  final pastAppointment =
                                      pastAppointmentsModel.records![index];
                                  return AppointmentItem(
                                    id: pastAppointment.id,
                                    type: getAppointmentType(pastAppointment),
                                    date: formattedDate(
                                        pastAppointment.startTime),
                                    status: getActualStatus(
                                        pastAppointment.actualEndTime),
                                  );
                                },
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              height: 18.0,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'You do not have past appointments.',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppointmentItem extends StatelessWidget {
  final int? id;
  final String? type;
  final String? date;
  final dynamic? status;
  const AppointmentItem({
    super.key,
    this.id,
    this.type,
    this.date,
    this.status = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12.0, right: 10, bottom: 4, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Date: $date',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF2A3786),
                          ),
                        ),
                      ),
                      if (status == 'Attended')
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 130, 189, 79),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '${AppRoutes.appointmentsPage}/details',
                              arguments: id);
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "View details",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF6048DE),
                                ),
                              ),
                              WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.0),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF6048DE),
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
