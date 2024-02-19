import 'package:flutter/gestures.dart';
import 'package:src/presentation/appViews/home_screen/webView.dart';
import 'package:src/presentation/appViews/logout_screen.dart';
import 'package:src/presentation/widgets/custom_card.dart';
import 'package:src/utils/app_export.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class SettingsScreen extends StatelessWidget {
  late List<Map<String, dynamic>> myCardDataAccSettings;
  late List<Map<String, dynamic>> myCardDataOther;
  SettingsScreen({Key? key})
      : super(
          key: key,
        ) {
    myCardDataAccSettings = [
      {
        "iconData": 'assets/images/app_icons/Your-Account.png',
        "text": "Your Account",
        "route": '${AppRoutes.settingsPage}/account',
      },
      {
        "iconData": Icons.lock,
        "text": "Authentication Settings",
        "route": '${AppRoutes.settingsPage}/authConfig',
      },
      {
        "iconData": 'assets/images/app_icons/Notification-Settings.png',
        "text": "Notification Settings",
        "route": '${AppRoutes.settingsPage}/notifications',
      },
      if (Platform.isAndroid)
        {
          "iconData": 'assets/images/app_icons/Rate-and-Review.png',
          "text": "Rate & review",
          "route":
              'https://play.google.com/store/apps/details?id=com.psychiatryuk.src',
        },
      {
        "iconData": 'assets/images/app_icons/Help.png',
        "text": "Help",
        "route": '${AppRoutes.settingsPage}/help',
      },
    ];
  }

  @override
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
          child: const Icon(
            Icons.settings,
            color: Color(0xFFd1d5db),
            size: 36.0,
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
          child: const Icon(
            Icons.settings,
            color: Color(0xFFd1d5db),
            size: 36.0,
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    Widget imgHeaderWidget;
    double normalTextFontSize =
        SizeUtils.calculateHomeNormalTextFontSize(context);
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      imgHeaderWidget = _buildImgHeaderPortrait();
    } else {
      imgHeaderWidget = _buildImgHeaderLandScape(context);
    }
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 36,
                  top: 20,
                  right: 36,
                ),
                child: Column(
                  children: [
                    imgHeaderWidget,
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        "Application Settings",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A3786)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.only(top: 22.0, bottom: 10.0),
                        child: Center(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: myCardDataAccSettings.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CustomCard(
                                  iconData: myCardDataAccSettings[index]
                                      ["iconData"],
                                  text: myCardDataAccSettings[index]["text"],
                                  screenRoute: myCardDataAccSettings[index]
                                      ["route"],
                                  fnEvent: () async {
                                    if (myCardDataAccSettings[index]["route"] !=
                                        null) {
                                     Navigator.pushNamed(context,
                                          myCardDataAccSettings[index]["route"]);
                                    }
                                    if (myCardDataAccSettings[index]["text"] ==
                                        'Rate & review') {
                                      String storeUrl =
                                          myCardDataAccSettings[index]["route"];
                                      Uri playStoreUri = Uri.parse(storeUrl);
                                      await launchUrl(playStoreUri);
                                    }
                                  },
                                  );
                            },
                          ),
                        )),
                    const SizedBox(height: 40.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Center(
                          child: RichText(
                              text: TextSpan(children: [
                        TextSpan(
                          text: "Terms of Service ",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF6048DE),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WebViewContainer(
                                    url:
                                        "https://psychiatry-uk.com/terms-conditions/",
                                    token: '',
                                  ),
                                ),
                              );
                            },
                        ),
                        const TextSpan(
                          text: "and ",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF2A3786)),
                        ),
                        TextSpan(
                            text: "Privacy Policy",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF6048DE),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const WebViewContainer(
                                      url:
                                          "https://psychiatry-uk.com/data-protection-privacy-notice/",
                                      token: '',
                                    ),
                                  ),
                                );
                              }),
                      ]))),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 18.0, bottom: 20.0),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await _logout(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              side: const BorderSide(color: Color(0xFF2A3786)),
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 14.0),
                              fixedSize: const Size.fromWidth(260.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Expanded(
                                    child: Text(
                                  'Log out from App',
                                  style: TextStyle(
                                    color: Color(0xFF2A3786),
                                    fontSize: 14,
                                  ),
                                )),
                                const SizedBox(width: 8.0),
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF6048DE),
                                  ),
                                  child: const Icon(Icons.arrow_forward,
                                      color: Colors.white, size: 15.0),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            )));
  }

  Future<void> _logout(BuildContext context) async {
    // Show a confirmation dialog
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Yes
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LogoutScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }
}
