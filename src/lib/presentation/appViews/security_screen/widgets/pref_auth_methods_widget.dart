import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:src/data/model/pref_auth_methods_model.dart';
import 'package:src/presentation/appViews/security_screen/bloc/pref_auth_methods_bloc.dart';
import 'package:src/utils/app_export.dart';
import 'package:motion_toast/motion_toast.dart';

class PrefAuthMethodsWidget extends StatefulWidget {
  final PrefauthMethodsModel prefAuthMethodsModel;
  const PrefAuthMethodsWidget({Key? key, required this.prefAuthMethodsModel});

  @override
  State<PrefAuthMethodsWidget> createState() =>
      _PrefAuthMethodsState(this.prefAuthMethodsModel);
}

class _PrefAuthMethodsState extends State<PrefAuthMethodsWidget> {
  final PrefauthMethodsModel prefAuthMethodsModel;
  late List<Map<String, dynamic>> notificationsList;
  late List<Map<String, dynamic>> dataList;

  _PrefAuthMethodsState(this.prefAuthMethodsModel);
  @override
  void initState() {
    super.initState();
  }

  Widget _buildImgHeaderPortrait(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomImageView(
              imagePath: ImageConstant.imgHeader, width: size.width * 1.0),
        ),
        Container(
          margin: EdgeInsets.only(left: 15.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.settingsPage);
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

  Widget _buildImgHeaderLandScape(BuildContext context) {
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
            Navigator.pushNamed(context, AppRoutes.settingsPage);
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

  void saveInfoSubmit() {
    CustomRadioButtonGroup customRadioButtonGroup =
        CustomRadioButtonGroup(prefauthValuesState: prefAuthMethodsModel);
    customRadioButtonGroup.getCheckboxValues();

    dynamic body = customRadioButtonGroup.getCheckboxValues();

    Iterable<String> prefObjKeysArray = body.keys;
    int sumCheck = 0;

    prefObjKeysArray.forEach((String key) {
      if (body[key] == true && key != 'fingerprint') sumCheck = sumCheck + 1;
    });

    if (sumCheck >= 1) {
      try {
        context.read<PrefAuthMethodsBloc>().add(UpdatePrefAuthMethods(body));
      } catch (e) {
        print('Error when updating: $e');
      }
    } else {
      String warningMessage =
          'At least one authentication method must be selected';
      if (body['fingerprint'] == true)
        warningMessage =
            'If you choose Biometrics, please choose also another one';
      MotionToast.warning(
        title: const Text(
          'Warning',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        description: Text(warningMessage),
        animationType: AnimationType.fromTop,
        position: MotionToastPosition.bottom,
        animationDuration: const Duration(seconds: 10),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    Widget imgHeaderWidget;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      imgHeaderWidget = _buildImgHeaderPortrait(context);
    } else {
      imgHeaderWidget = _buildImgHeaderLandScape(context);
    }

    String messageText = '';
    messageText =
        'We recommend enabling the app authenticator method. This is the most effective way of logging into the application.';

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
                            Navigator.pushNamed(
                                context, AppRoutes.settingsPage);
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
                            'Authentication Settings',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A3786)),
                          ),
                        )),
                  ],
                ),
              ),
              const Center(
                child: Text('Set your authentication preferences here',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A3786),
                    ),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 15.0),
              Center(
                  child: Text(messageText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF2A3786),
                      ),
                      textAlign: TextAlign.center)),
              const SizedBox(height: 25.0),
              Center(
                child: CustomRadioButtonGroup(
                    prefauthValuesState: prefAuthMethodsModel),
              ),
              const SizedBox(height: 20.0),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () async {
                    saveInfoSubmit();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: const BorderSide(color: Color(0xFF6048DE)),
                    backgroundColor: const Color(0xFF6048DE),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 14.0,
                    ),
                    fixedSize: const Size.fromWidth(260.0),
                  ),
                  child: Text(
                    'Save Info'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ])),
      ),
    ));
  }
}

class CustomRadioButtonGroup extends StatefulWidget {
  final dynamic prefauthValuesState;

  const CustomRadioButtonGroup({super.key, required this.prefauthValuesState});

  dynamic getCheckboxValues() {
    dynamic bodyObj = {
      "sms": prefauthValuesState.prefAuthMethodApp.sms,
      "call": prefauthValuesState.prefAuthMethodApp.call,
      "email": prefauthValuesState.prefAuthMethodApp.email,
      "fingerprint": prefauthValuesState.prefAuthMethodApp.fingerprint,
      "authenticatorApp": prefauthValuesState.prefAuthMethodApp.authenticatorApp
    };

    return bodyObj;
  }

  @override
  _CustomRadioButtonGroupState createState() => _CustomRadioButtonGroupState();
}

class _CustomRadioButtonGroupState extends State<CustomRadioButtonGroup> {
  @override
  Widget buildCheckboxListTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool?> onChanged,
    Icon icon,
    bool disabled,
  ) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      activeColor: disabled ? const Color(0xFFd1d5db) : const Color(0xFF2A3786),
      title: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                overflow: TextOverflow.ellipsis,
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: disabled
                      ? const Color(0xFFd1d5db)
                      : const Color(0xFF2A3786),
                ),
              ),
            ),
          ),
          icon,
        ],
      ),
      subtitle: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Text(subtitle,
            style: TextStyle(
              fontSize: 14,
              color:
                  disabled ? const Color(0xFFd1d5db) : const Color(0xFF2A3786),
            )),
      ),
      isThreeLine: true,
    );
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.prefauthValuesState.enabledMethods.authenticatorApp)
          buildCheckboxListTile(
            'Authentication App',
            'Authenticate with an authentication app. This may require assistance from P-UK support.',
            widget.prefauthValuesState.prefAuthMethodApp.authenticatorApp,
            (bool? value) {
              setState(() {
                widget.prefauthValuesState.prefAuthMethodApp.authenticatorApp =
                    value!;
              });
            },
            const Icon(
              Icons.vpn_key,
              color: Color(0xFF2A3786),
              size: 23.0,
            ),
            false,
          ),
        const Divider(height: 0),
        if (widget.prefauthValuesState.enabledMethods.fingerprint)
          buildCheckboxListTile(
            'Fingerprint / Face ID',
            'Authenticate with the biometric system on your phone.',
            widget.prefauthValuesState.prefAuthMethodApp.fingerprint,
            (bool? value) {
              setState(() {
                widget.prefauthValuesState.prefAuthMethodApp.fingerprint =
                    value!;
              });
            },
            const Icon(
              Icons.fingerprint,
              color: Color(0xFF2A3786),
              size: 23.0,
            ),
            false,
          ),
        const Divider(height: 0),
        if (widget.prefauthValuesState.enabledMethods.email)
          buildCheckboxListTile(
            'Email',
            'Authenticate with a code sent to the e-mail address on your portal account.',
            widget.prefauthValuesState.prefAuthMethodApp.email,
            (bool? value) {
              setState(() {
                widget.prefauthValuesState.prefAuthMethodApp.email = value!;
              });
            },
            const Icon(
              Icons.email,
              color: Color(0xFF2A3786),
              size: 23.0,
            ),
            false,
          ),
        const Divider(height: 0),
        if (widget.prefauthValuesState.enabledMethods.call)
          buildCheckboxListTile(
            'Phone Call',
            'Authenticate with an automatic call on the mobile number on your portal account.',
            widget.prefauthValuesState.prefAuthMethodApp.call,
            (bool? value) {
              setState(() {
                widget.prefauthValuesState.prefAuthMethodApp.call = value!;
              });
            },
            const Icon(
              Icons.phone,
              color: Color(0xFF2A3786),
              size: 23.0,
            ),
            false,
          ),
        const Divider(height: 0),
        if (widget.prefauthValuesState.enabledMethods.sms)
          buildCheckboxListTile(
            'SMS',
            'Authenticate with a code sent to the mobile number on your portal account.',
            widget.prefauthValuesState.prefAuthMethodApp.sms,
            (bool? value) {
              setState(() {
                widget.prefauthValuesState.prefAuthMethodApp.sms = value!;
              });
            },
            const Icon(
              Icons.sms,
              color: Color(0xFF2A3786),
              size: 23.0,
            ),
            false,
          ),
        const Divider(height: 0),
      ],
    );
  }
}
