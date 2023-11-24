import 'package:application_base/appViews/main_screen.dart';
import 'package:application_base/core/app_export.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: size.width,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgHeader,
                      height: getVerticalSize(100),
                      //width: getHorizontalSize(136),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Text(
                            "Welcome 👋",
                            style: TextStyle(
                              fontSize: 26,
                              color: Color(0xFF2A3786),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "MedQare Companion App",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF2A3786),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          side: BorderSide(color: Color(0xFF6048DE)),
                          backgroundColor: Color(0xFF6048DE),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 14.0,
                          ),
                          fixedSize: Size.fromWidth(200.0),
                        ),
                        child: Text(
                          'Log in'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: size.width,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Powered by Psychiatry-UK',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94a3b8),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
