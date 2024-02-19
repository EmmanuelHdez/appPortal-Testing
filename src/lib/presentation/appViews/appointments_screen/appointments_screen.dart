import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:src/config/config.dart';
import 'package:src/dependency_injection_container.dart';
import 'package:src/presentation/appViews/appointments_screen/bloc/appointments_bloc.dart';
import 'package:src/presentation/appViews/appointments_screen/widgets/appointments_widget.dart';
import 'package:src/presentation/appViews/logout_screen.dart';

import 'package:src/presentation/shared/loading_widget.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppointmentsBloc>(),
      child: Builder(builder: (context) {
        final bloc = context.watch<AppointmentsBloc>();
        return Scaffold(
          body: BlocBuilder<AppointmentsBloc, AppointmentsState>(
            builder: (context, state) {
              if (state is AppointmentsInitial) {
                bloc.add(const AppointmentsGetPatientId(PATIENT_ID));
              } else if (state is AppointmentsLoading) {
                return const LoadingWidget();
              } else if (state is AppointmentsPatientIdLoaded) {
                _makeRequest(context, state.patientId);
              } else if (state is AllAppointmentsLoaded) {
                return AppointmentsWidget(
                  patientName: state.patientName,
                  futureAppointmentsModel: state.appointmentsModel,
                  pastAppointmentsModel: state.pastAppointmentsModel,
                );
              } else if (state is AppointmentsError) {
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

  void _makeRequest(BuildContext context, int patientId) {
    context.read<AppointmentsBloc>().add(FetchFutureAppointments(patientId));
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
