import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Utils {
  
  static double windowWidth(BuildContext context){
    return MediaQuery.sizeOf(context).width;
  }
  static double windowHeight (BuildContext context){
    // return MediaQuery.of(context).size.height;
    return MediaQuery.sizeOf(context).height;
  }
 
  static dynamic layout(BuildContext context) {
    return ResponsiveBreakpoints.of(context);
  }
  
}

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isMobile;
  }

  static bool isTablet(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isTablet;
  }

  static bool isDesktop(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isDesktop;
  }
  static bool is4KScreen(BuildContext context) {
    return ResponsiveBreakpoints.of(context).breakpoint.name?.toUpperCase() == '4K';
  }
}