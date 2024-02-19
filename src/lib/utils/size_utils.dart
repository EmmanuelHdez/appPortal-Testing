import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// This is where the magic happens.
// This functions are responsible to make UI responsive across all the mobile devices.
MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);

Size size = WidgetsBinding.instance.window.physicalSize /
    WidgetsBinding.instance.window.devicePixelRatio;

// Caution! If you think these are static values and are used to build a static UI,  you mustn’t.
// These are the Viewport values of your Figma Design.
// These are used in the code as a reference to create your UI Responsively.
const num FIGMA_DESIGN_WIDTH = 375;
const num FIGMA_DESIGN_HEIGHT = 812;
const num FIGMA_DESIGN_STATUS_BAR = 0;

///This method is used to get device viewport width.
double get width {
  double fullWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.width;
  if (MediaQueryData.fromWindow(WidgetsBinding.instance!.window).orientation ==
      Orientation.portrait) {
    return fullWidth;
  } else {
    return fullWidth * 0.5;
  }
}

///This method is used to get device viewport height.
get height {
  num statusBar =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).viewPadding.top;
  num bottomBar = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
      .viewPadding
      .bottom;
  num screenHeight = size.height - statusBar - bottomBar;
  return screenHeight;
}

///This method is used to set padding/margin (for the left and Right side) & width of the screen or widget according to the Viewport width.
double getHorizontalSize(double px) {
  return ((px * width) / FIGMA_DESIGN_WIDTH);
}

///This method is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
double getVerticalSize(double px) {
  return ((px * height) / (FIGMA_DESIGN_HEIGHT - FIGMA_DESIGN_STATUS_BAR));
}

///This method is used to set smallest px in image height and width
double getSize(double px) {
  var height = getVerticalSize(px);
  var width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

///This method is used to set text font size according to Viewport
double getFontSize(double px) {
  return getSize(px);
}

///This method is used to set padding responsively
EdgeInsetsGeometry getPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

///This method is used to set margin responsively
EdgeInsetsGeometry getMargin({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

///This method is used to get padding or margin responsively
EdgeInsetsGeometry getMarginOrPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  if (all != null) {
    left = all;
    top = all;
    right = all;
    bottom = all;
  }
  return EdgeInsets.only(
    left: getHorizontalSize(
      left ?? 0,
    ),
    top: getVerticalSize(
      top ?? 0,
    ),
    right: getHorizontalSize(
      right ?? 0,
    ),
    bottom: getVerticalSize(
      bottom ?? 0,
    ),
  );
}

// Welcome Page Utils
class SizeUtils {
  // Text Utils
  static double calculateWelcomeTextFontSize(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width < 600
            ? 22.0
            : 35.0
        : MediaQuery.of(context).size.width < 1000
            ? 26.0
            : 45.0;
  }

  static double calculateNormalTextFontSize(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width < 600
            ? 15.0
            : 22.0
        : MediaQuery.of(context).size.width < 1000
            ? 15.0
            : 25.0;
  }

  static double calculateBtnWelcomeText(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width < 600
            ? 11.0
            : 16.0
        : MediaQuery.of(context).size.width < 1000
            ? 13.0
            : 18.0;
  }

  static double calculateSmallRegisteredText(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width < 600
            ? 10.0
            : 15.0
        : MediaQuery.of(context).size.width < 1000
            ? 12.0
            : 17.0;
  }

  // Welcome Screen Utils

  static double calculateMainHeaderFontSize(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width < 600
            ? 18.0
            : 25.0
        : MediaQuery.of(context).size.width < 1000
            ? 19.0
            : 25.0;
  }

  static double calculateHomeNormalTextFontSize(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width < 600
            ? 12.5
            : 14.0
        : MediaQuery.of(context).size.width < 1000
            ? 12.0
            : 14.0;
  }

  static double calculatePaddingContent(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width < 600
            ? 16.0
            : 40.0
        : MediaQuery.of(context).size.width < 1000
            ? 15.0
            : 20.0;
  }

  static double calculateIconSize(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width < 600
            ? 20.0
            : 30.0
        : MediaQuery.of(context).size.width < 1000
            ? 22.0
            : 30.0;
  }

  static double calculateSecondaryIconSize(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width < 600
            ? 12.0
            : 15.0
        : MediaQuery.of(context).size.width < 1000
            ? 10.0
            : 14.0;
  }

  static double calculateBtnFontSize(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width < 600
            ? 11.0
            : 14.0
        : MediaQuery.of(context).size.width < 1000
            ? 12.0
            : 15.0;
  }

  static const double navBarIconSize = 23.0;
  static const double iconSize = 18.0;
}
