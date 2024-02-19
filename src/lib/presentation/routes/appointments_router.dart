import 'package:flutter/material.dart';
import 'package:src/presentation/appViews/appointment_details_screen/appointments_details_screen.dart';
import 'package:src/presentation/appViews/appointments_screen/appointments_screen.dart';

class AppointmentsRouter extends StatelessWidget {
  const AppointmentsRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(onGenerateRoute: (appointments) {
        switch (appointments.name) {
          case '/appointments_screen/details':
          final appointmentId = appointments.arguments;
           return MaterialPageRoute(
                builder: (BuildContext context) => AppointmentsDetailsScreen(appointmentIdArg: appointmentId));
          default:
            return MaterialPageRoute(
                builder: (BuildContext context) => const AppointmentsScreen());
        }
      }),
    );
  }
}