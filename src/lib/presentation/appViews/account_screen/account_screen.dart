import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:src/dependency_injection_container.dart';
import 'package:src/presentation/appViews/account_screen/widgets/account_widget.dart';
import 'package:src/presentation/appViews/account_screen/bloc/account_bloc.dart';
import 'package:src/presentation/appViews/logout_screen.dart';
import 'package:src/presentation/shared/loading_widget.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AccountBloc>(),
      child: Builder(builder: (context) {
        final bloc = context.watch<AccountBloc>();
        return Scaffold(
          body: BlocBuilder<AccountBloc, AccountState>(
            builder: (context, state) {
              if (state is AccountInitial) {
                _makeRequest(context);
              } else if (state is AccountLoading) {
                return const LoadingWidget();
              } else if (state is AccountLoaded) {
                return AccountWidget(
                  accountModel: state.accountModel,
                );
              } else if (state is AccountError) {
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
              } else if (state is UploadPhotoLoaded) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushNamed(context, '/settings_screen/account');
                  MotionToast.success(
                    title: const Text(
                      'Success',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    description: const Text("Photo uploaded!"),
                    animationType: AnimationType.fromBottom,
                    position: MotionToastPosition.bottom,
                    animationDuration: const Duration(seconds: 10),
                  ).show(context);
                });
              }
              return Container();
            },
          ),
        );
      }),
    );
  }

  void _makeRequest(BuildContext context) {
    context.read<AccountBloc>().add(const FetchPatient());
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
