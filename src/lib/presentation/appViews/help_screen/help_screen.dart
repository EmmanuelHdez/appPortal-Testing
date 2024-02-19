import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:src/utils/app_export.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:src/presentation/appViews/home_screen/webView.dart';

class HelpSettings extends StatelessWidget {
  const HelpSettings({Key? key}) : super(key: key);

  void _launchPhoneCall(String phoneNumber) async {
    final url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
          child: Icon(
            Icons.settings,
            color: Color(0xFFd1d5db),
            size: 36.0,
          ),
        ),
      ],
    );
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
            padding: EdgeInsets.only(
              left: 36,
              top: 20,
              right: 36,
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              imgHeaderWidget,
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 20, left: 11, right: 11),
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
                            'Help',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A3786)),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  color: Color(0xFFFDF2F2),
                  borderRadius: BorderRadius.circular(
                      10.0), // Ajusta el valor según tus necesidades
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/app_icons/Urgent.png'),
                      width: 23,
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Do you need urgent medical assistance?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text:
                                      "Psychiatry-UK is an online service only and therefore is not able to offer an emergency service. Please ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF2A3786),
                                  ),
                                ),
                                TextSpan(
                                  text: "refer to our advice",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.red,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const WebViewContainer(
                                            url:
                                                "https://psychiatry-uk.com/urgent-help/",
                                            token: '',
                                          ),
                                        ),
                                      );
                                    },
                                ),
                                const TextSpan(
                                  text: " on how to get assistance.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF2A3786),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 15, bottom: 15),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage('assets/images/app_icons/Staff-Portal.png'),
                      width: 23,
                    ),
                    SizedBox(width: 25.0),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "If you wish to contact a particular member of staff, please leave a note in your MedQare portal. ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF2A3786),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.0),
                child: Divider(height: 0),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 15, bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/app_icons/FAQs.png'),
                      width: 23,
                    ),
                    SizedBox(width: 25.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "You can find frequently asked questions on our website.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF2A3786),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WebViewContainer(
                                    url:
                                        "https://psychiatry-uk.com/frequently-asked-questions/",
                                    token: '',
                                  ),
                                ),
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "View our FAQs",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6048DE),
                                    ),
                                  ),
                                  const WidgetSpan(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Color(0xFF6048DE),
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.0),
                child: Divider(height: 0),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/app_icons/Call.png'),
                      width: 23,
                    ),
                    SizedBox(width: 25.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "If you do need to speak to a member of our team telephone: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF2A3786),
                                  ),
                                ),
                                TextSpan(
                                  text: "0330 124 1980",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2A3786),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _launchPhoneCall("03301241980");
                                    },
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '(Mon-Fri: 8am-8pm: Sat-Sun: 9am-5pm)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF2A3786),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0x80bfdbfe),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Ajusta el valor según tus necesidades
                            ),
                            child: Text(
                              "Please note: Our phone lines are extremely busy and we regret that you may be on hold for some time. We are bringing new staff on board as quickly as possible to minimise delays.",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF2A3786),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ])),
      ),
    ));
  }
}
