import 'package:flutter/material.dart';
import 'package:src/utils/app_export.dart';

import 'package:motion_toast/motion_toast.dart';

void displayPukCompanionModal(BuildContext context, String? modalTitle,
    String? modalText, bool dispayCloseButton, bool? logo, Function()? onButtonPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      mediaQueryData = MediaQuery.of(context);

      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: SingleChildScrollView(
          // Wrap the content with SingleChildScrollView
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (logo != null && logo == true)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgHeader,
                    width: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.width < 600
                            ? getHorizontalSize(size.width * 0.9)
                            : getHorizontalSize(250)
                        : MediaQuery.of(context).size.width < 1000
                            ? getHorizontalSize(size.width * 0.7)
                            : getHorizontalSize(350),
                  ),
                ),
                if (modalTitle != null)
                  Column(
                    children: [
                      Text(
                        modalTitle,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A3786)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                if (modalText != null)
                  Column(
                    children: [
                      Text(
                        modalText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF2A3786),
                          wordSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (dispayCloseButton == true)
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Close",
                          style: TextStyle(
                            color: const Color(0xFF2A3786),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    SizedBox(width: 10),
                    if (onButtonPressed != null)
                      ElevatedButton(
                        onPressed: () {
                          onButtonPressed();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF6048DE),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: const Text("Ok",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            )),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
