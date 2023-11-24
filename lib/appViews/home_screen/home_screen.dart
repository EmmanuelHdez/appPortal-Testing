import 'package:application_base/core/app_export.dart';
import 'package:flutter/material.dart';
import 'webView.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({Key? key})
      : super(
          key: key,
        );
  final List<Map<String, dynamic>> myCardData = [
    {"iconData": Icons.event, "text": "Appointments", "notificationCount": 1},
    {
      "iconData": Icons.description,
      "text": "Your Forms",
      "notificationCount": 2
    },
    {
      "iconData": Icons.mail_outline,
      "text": "Unread Portal Notes",
      "notificationCount": 2
    },
  ];

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 36,
            top: 20,
            right: 36,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: mediaQueryData.size.width * 0.8,
                  child: Image(
                    image: AssetImage(ImageConstant.imgHeader),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: 15,
                ),
                child: Text(
                  "Hi there, {name} 👋",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700, // Semibold
                      color: Color(0xFF2A3786)),
                ),
              ),

              // Text Date

              Container(
                margin: EdgeInsets.only(
                  left: 23,
                  top: 15,
                  right: 23,
                ),
                child: Text.rich(
                  TextSpan(
                    text: "Your next appointment is on ",
                    style: TextStyle(
                      color: Color(0xFF2A3786),
                      fontSize: 14.0,
                    ),
                    children: [
                      TextSpan(
                        text: "DD/MM/YYYY",
                        style: TextStyle(
                          color: Color(0xFF6048DE),
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " with Dr Name and Surname",
                        style: TextStyle(
                          color: Color(0xFF2A3786),
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                  ),
                ),
              ),

              //Notification Card

              Container(
                width: mediaQueryData.size.width * 0.8,
                margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700, // Semibold
                            color: Color(0xFF2A3786)),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: myCardData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MyCustomCard(
                          iconData: myCardData[index]["iconData"],
                          text: myCardData[index]["text"],
                          notificationCount: myCardData[index]
                              ["notificationCount"],
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Button
              Container(
                margin: EdgeInsets.only(top: 18.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewContainer(
                          url:
                              'https://pukauth-dev.herokuapp.com/loginstart/089656512',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    side: BorderSide(color: Color(0xFF2A3786)),
                    backgroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 13.0, horizontal: 14.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Access your MedQare Portal',
                        style: TextStyle(
                          color: Color(0xFF2A3786),
                          fontSize: 11.0,
                        ),
                      ),
                      SizedBox(width: 6.0),
                      Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF6048DE),
                        ),
                        child: Icon(Icons.arrow_forward,
                            color: Colors.white, size: 11.0),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomCard extends StatelessWidget {
  final IconData iconData;
  final String text;
  final int notificationCount;

  const MyCustomCard({
    required this.iconData,
    required this.text,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Color(0xFFF1F5F9),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(9.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    iconData,
                    color: Color(0xFF2A3786),
                    size: 20.0,
                  ),
                ),
                SizedBox(width: 14.0),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF2A3786),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Text(
                notificationCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
