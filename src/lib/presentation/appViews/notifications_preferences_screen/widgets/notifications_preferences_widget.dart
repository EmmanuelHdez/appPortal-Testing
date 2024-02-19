import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/presentation/appViews/controls/puk_companion_modal.dart';
import 'package:src/presentation/appViews/notifications_preferences_screen/bloc/notification_settings_bloc.dart';
import 'package:src/presentation/routes/settings_router.dart';
import 'package:src/shared/shared_preferences.dart';
import 'package:src/utils/app_export.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  final NotificationSettingsModel notificationsModel;
  final dynamic firstLogin;
  const NotificationPreferencesWidget(
      {Key? key, required this.notificationsModel, this.firstLogin})
      : super(key: key);

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState(this.notificationsModel);
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  final NotificationSettingsModel notificationsModel;
  bool allNotifications = false;
  bool emailNotifications = false;
  bool appNotifications = false;
  bool noNotifications = false;
  bool pushNotifications = false;
  _NotificationPreferencesWidgetState(this.notificationsModel);

  _validateStateVars() {
    if (notificationsModel.notificationSetting != 'sms') {
      setState(() {
        pushNotifications = true;
      });
    }
  }

  _submitNotificationSettings() {
    try {
      final String notificationSetting =
          pushNotifications == true ? 'pushNotifications' : 'sms';

      context
          .read<NotificationSettingsBloc>()
          .add(SubmitNotificationSettings(notificationSetting));
    } catch (e) {
      print('Error when creating a note: $e');
    }
  }

  _onChangeNotification() {
    setState(() {
      pushNotifications = !pushNotifications;
    });
    if (pushNotifications == false) {
      displayPukCompanionModal(
          context,
          'Warning',
          'This will turn off push notifications (Not recommended).',
          false,
          false,
          () => null);
    }
  }

  @override
  void initState() {
    super.initState();
    _doNotShowAfterFirstLogin(context);
    _validateStateVars();
  }

  void _doNotShowAfterFirstLogin(BuildContext context) async {
    final showconfigModal = await MySharedPreferences.instance
        .getIntValue(SHOW_CONFIG_SETTINGS_MODAL);
    if (showconfigModal == 1) {
      int showSettingsValue = 0;
      // ignore: use_build_context_synchronously
      context
          .read<NotificationSettingsBloc>()
          .add(ValidateNotificationSettingsScreen(showSettingsValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imgHeaderWidget;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      imgHeaderWidget = _buildImgHeaderPortrait(context);
    } else {
      imgHeaderWidget = _buildImgHeaderLandScape(context);
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
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            imgHeaderWidget,
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 20),
              child: Row(
                mainAxisAlignment:
                    widget.firstLogin == null || widget.firstLogin == 0
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                children: [
                  if (widget.firstLogin == null || widget.firstLogin == 0)
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsRouter()));
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
                        child:  Text(
                          overflow: TextOverflow.ellipsis,
                          textAlign: widget.firstLogin == null || widget.firstLogin == 0 ? null : TextAlign.center,
                          maxLines: 2,
                          'Notifications Settings',
                          style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A3786)),
                        ),
                      )),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: const Text(
                  'How would you like to be notified by Psychiatry-UK?',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A3786),
                  ),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 15.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Color(0xFF2A3786),
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                  ),
                  children: [
                    TextSpan(
                      text: 'We recommend enabling ',
                    ),
                    TextSpan(
                      text: 'push notifications.',
                      style: TextStyle(
                        color: Color(0xFF6048DE),
                      ),
                    ),
                    TextSpan(
                      text:
                          '\n This is the most effective way of keeping you up-to-date',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Center(
                child: _customRadioButtonGroup(
                    _onChangeNotification, pushNotifications, context)),
            const SizedBox(height: 20.0),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () async {
                  _submitNotificationSettings();
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
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    ));
  }

  Widget _buildImgHeaderPortrait(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomImageView(
              imagePath: ImageConstant.imgHeader, width: size.width * 1.0),
        ),
        if (widget.firstLogin == null || widget.firstLogin == 0)
          Container(
            margin: const EdgeInsets.only(left: 15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
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
        if (widget.firstLogin == null || widget.firstLogin == 0)
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
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
}

Widget _customRadioButtonGroup(
    Function() fnAllNotification, bool pushNotification, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      customRadioButton(
          'Push Notification', fnAllNotification, pushNotification, context),
      const SizedBox(height: 12.0),
      customRadioButton('SMS', fnAllNotification, !pushNotification, context),
      const SizedBox(height: 12.0),
    ],
  );
}

Widget customRadioButton(
    String label, Function() onChanged, bool value, BuildContext context) {
  double normalText = SizeUtils.calculateHomeNormalTextFontSize(context);
  return InkWell(
    onTap: onChanged,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Color(0xFF2A3786)),
        ),
        Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value ? const Color(0xFF6048DE) : Colors.white,
            border: Border.all(
              color: const Color(0xFF6048DE),
              width: 2.0,
            ),
          ),
          child: value
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16.0,
                )
              : null,
        ),
      ],
    ),
  );
}
