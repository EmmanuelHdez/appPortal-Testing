import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:src/dependency_injection_container.dart';
import 'package:src/presentation/appViews/logout_screen.dart';
import 'package:src/presentation/appViews/navigation_bar/main_screen.dart';
import 'package:src/presentation/appViews/notifications_preferences_screen/bloc/notification_settings_bloc.dart';
import 'package:src/presentation/appViews/notifications_preferences_screen/widgets/notifications_preferences_widget.dart';
import 'package:src/presentation/routes/settings_router.dart';
import 'package:src/presentation/shared/loading_widget.dart';

class NotificationsPreferencesScreen extends StatelessWidget {
  final dynamic firstLogin;
  const NotificationsPreferencesScreen({super.key, this.firstLogin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<NotificationSettingsBloc>(),
        child:
            BlocListener<NotificationSettingsBloc, NotificationSettingsState>(
          listener: (context, state) async {
            if (state is NotificationSettingsSubmitted) {
              if (firstLogin == 1) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainScreen()));
              } else {
                Navigator.pop(context);
              }

              MotionToast.success(
                title: const Text(
                  'Success',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                description: const Text("Notification settings updated!"),
                animationType: AnimationType.fromTop,
                position: MotionToastPosition.bottom,
                animationDuration: const Duration(seconds: 10),
              ).show(context);
            }
          },
          child:
              BlocBuilder<NotificationSettingsBloc, NotificationSettingsState>(
            builder: (context, state) {
              return Scaffold(body: BlocBuilder<NotificationSettingsBloc,
                  NotificationSettingsState>(builder: (context, state) {
                if (state is NotificationSettingsInitial) {
                  _makeRequest(context);
                } else if (state is NotificationSettingsLoading) {
                  return const LoadingWidget();
                } else if (state is NotificationSettingsLoaded) {
                  return NotificationPreferencesWidget(
                      firstLogin: firstLogin,
                      notificationsModel: state.notificationSettingsModel);
                } else if (state is NotificationSettingsError) {
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
              }));
            },
          ),
        ));
  }

  void _showErrorModal(String message, BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: message,
    );
  }

  void _makeRequest(BuildContext context) {
    context
        .read<NotificationSettingsBloc>()
        .add(const GetNotificationSettings());
  }
}
