import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:src/config/config.dart';
import 'package:src/dependency_injection_container.dart';
import 'package:src/presentation/appViews/forms_screen/bloc/forms_bloc.dart';
import 'package:src/presentation/appViews/forms_screen/widget/forms_widget.dart';
import 'package:src/presentation/appViews/home_screen/webView.dart';
import 'package:src/presentation/appViews/logout_screen.dart';
import 'package:src/presentation/routes/app_routes.dart';
import 'package:src/presentation/shared/loading_widget.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class FormsScreen extends StatelessWidget {
  const FormsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    return BlocProvider(
      create: (_) => sl<FormsBloc>(),
      child: Builder(builder: (context) {
        final bloc = context.watch<FormsBloc>();
        return Scaffold(
          body: BlocBuilder<FormsBloc, FormsState>(
            builder: (context, state) {
              if (state is FormsInitial) {
                bloc.add(const FormsGetPatientId(PATIENT_ID));
              } else if (state is FormsLoading) {
                return const LoadingWidget();
              } else if (state is FormsPatientIdLoaded) {
                _makeRequest(context, state.patientId);
              } else if (state is FormsLoaded) {
                return FormsWidgets(
                    formCollectionsModel: state.formsModel,
                    patientName: state.patientName);
              } else if (state is FormTokenReceived) {
                _openWebViewForm(context, state.result.token, state.form);
              } else if (state is FormsError) {
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
    context.read<FormsBloc>().add(FetchForms(patientId));
  }

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
            nameRoute: AppRoutes.formsScreenPage,
          ),
        ),
      );
    });
  }
}
