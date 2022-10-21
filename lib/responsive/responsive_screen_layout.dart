import 'package:flutter/cupertino.dart';

import '../utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > webScreenSize) {
          //webscreen
          return webScreenLayout;
        }
        //mobile screen
        return mobileScreenLayout;
      },
    );
  }
}
