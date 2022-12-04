import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

const Widget kHeight50 = SizedBox(
  height: 50,
);
const Widget kHeight25 = SizedBox(
  height: 25,
);
const Widget kHeight10 = SizedBox(
  height: 10,
);
const Widget kWidth15 = SizedBox(
  width: 15,
);
const Widget circularProgressIndicator = Center(
  child: CircularProgressIndicator(
    color: Colors.white,
  ),
);

const AssetImage profilePlaceHolder =
    AssetImage('assets/images/circleProfile.png');

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    required this.centerTitle,
    required this.backgroundColor,
    required this.elevation,
  });
  final String title;
  final bool centerTitle;
  final Color backgroundColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

//circle avatar
class CircleAvatarWidget extends StatelessWidget {
  const CircleAvatarWidget(
      {super.key, required this.networkImagePath, this.radius = 20});

  final String networkImagePath;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      onForegroundImageError: (Object exception, StackTrace? stackTrace) =>
          profilePlaceHolder,
      backgroundImage: profilePlaceHolder,
      foregroundImage: NetworkImage(
        networkImagePath,
      ),
    );
  }
}

Future<bool> onBackButtonPressed(BuildContext context) async {
  final bool? exitApp = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Really'),
        content: const Text('Do you want to close the app?'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('No')),
          TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Yes'))
        ],
      );
    },
  );
  return exitApp!;
}
