import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:src/dependency_injection_container.dart';
import 'package:src/presentation/appViews/logout_screen.dart';
import 'package:src/presentation/appViews/security_screen/bloc/pref_auth_methods_bloc.dart';
import 'package:src/presentation/appViews/security_screen/widgets/pref_auth_methods_widget.dart';
import 'package:src/presentation/routes/app_routes.dart';
import 'package:src/presentation/shared/loading_widget.dart';
import 'package:src/config/config.dart';
import 'package:src/shared/shared_preferences.dart';
import 'package:src/shared/user_preferences.dart';
import 'package:motion_toast/motion_toast.dart';

class PrefAuthMethodsScreen extends StatelessWidget {
  const PrefAuthMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PrefAuthMethodsBloc>(),
      child: Builder(builder: (context) {
        final bloc = context.watch<PrefAuthMethodsBloc>();
        return Scaffold(
          body: BlocBuilder<PrefAuthMethodsBloc, PrefAuthMethodsState>(
            builder: (context, state) {
              if (state is PrefauthMethodsInitial) {
                _makeRequest(context);
              } else if (state is PrefAuthMethodsLoading) {
                return const LoadingWidget();
              } else if (state is PrefauthMethodsLoaded) {
                return PrefAuthMethodsWidget(
                    prefAuthMethodsModel: state.prefauthMethodsModel);
              } else if (state is PrefAuthMethodsUpdated) {
                Future.microtask(() async {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    MotionToast.success(
                      title: const Text(
                        'Success',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      description:
                          const Text("Preferred Auth methods updated!"),
                      animationType: AnimationType.fromTop,
                      position: MotionToastPosition.bottom,
                      animationDuration: const Duration(seconds: 10),
                    ).show(Navigator.of(context).overlay!.context);
                  });

                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.settingsPage,
                  );
                });
              } else if (state is PrefAuthMethodsError) {
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

  void _makeRequest(BuildContext context) {
    context.read<PrefAuthMethodsBloc>().add(FetchPrefAuthMethods());
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
