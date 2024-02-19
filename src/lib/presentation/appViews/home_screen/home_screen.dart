import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/dependency_injection_container.dart';
import 'package:src/presentation/appViews/home_screen/bloc/home_bloc.dart';
import 'package:src/presentation/appViews/home_screen/onboarding_widget.dart';
import 'package:src/presentation/appViews/logout_screen.dart';
import 'package:src/presentation/appViews/navigation_bar/bloc/navigation_bar_bloc.dart';
import 'package:src/presentation/shared/loading_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>(),
      child: Builder(
        builder: (context) {
          final bloc = context.watch<HomeBloc>();
          return Scaffold(
            body: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeInitial) {
                  bloc.add(const HomeGetValues('patientId'));
                } else if (state is HomeLoading) {
                  return const LoadingWidget(); // Show loading widget.
                } else if (state is HomeValuesLoaded) {
                  _makeRequest(context, state.patientId);
                } else if (state is HomeNotificationsLoaded) {
                  _updateCounters(context, state.notificationsModel);
                  return OnboardingWidget(
                    notificationsModel: state.notificationsModel,
                    patientName: state.patientName,
                  );
                } else if (state is HomeError) {
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
                    _showErrorModal('Sorry, something went wrong', context);
                  }
                }
                return Container();
              },
            ),
          );
        },
      ),
    );
  }

  void _showErrorModal(String message, BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: message,
    );
  }

  void _makeRequest(BuildContext context, int patientId) {
    context.read<HomeBloc>().add(HomeFetchNotifications(patientId));
  }

  void _updateCounters(BuildContext context, List<NotificationsModel> list) {
    final int notesCounter = list
        .where((element) => element.component == 'notes')
        .firstOrNull!
        .count;
    final formsCounter = list
        .where((element) => element.component == 'formCollections')
        .firstOrNull!
        .count;
    final appointmentsCounter = list
        .where((element) => element.component == 'appointments')
        .firstOrNull!
        .count;
    final notificationsCounter = list
        .where((element) => element.component == 'totalElements')
        .firstOrNull!
        .count;
    context.read<NavigationBarBloc>().add(UpdateCounters(
        notesCounter, appointmentsCounter, formsCounter, notificationsCounter));
  }
}
