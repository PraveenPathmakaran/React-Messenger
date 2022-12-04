import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  functionText(
                      'React Messenger', Colors.white, FontWeight.bold, 35),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  functionTextButton(() {
                    Share.share('will update soon');
                  }, 'Share'),
                  functionTextButton(() {
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: const Text(
                              'Privacy Policy',
                            ),
                            content: const SingleChildScrollView(
                              child: Text(privacyPolicyContent),
                            ),
                            actions: <Widget>[
                              Center(
                                child: IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(Icons.close)),
                              )
                            ],
                          );
                        });
                  }, 'Privacy Policy'),
                  functionTextButton(() {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(12),
                            title: ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0,
                              leading: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    AssetImage('assets/images/google.png'),
                              ),
                              title: functionText('React\nMessenger',
                                  Colors.white, FontWeight.bold, 20),
                              subtitle: const Text(
                                  'Connect people with React Messenger'),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  showLicensePage(
                                      context: context,
                                      applicationName: 'React Messenger',
                                      applicationIcon: Image.asset(
                                        'assets/images/google.png',
                                        width: 50,
                                        height: 50,
                                      ));
                                },
                                child: const Text('View License'),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Close'))
                            ],
                          );
                        });
                  }, 'About'),
                  functionTextButton(() {
                    showDialog(
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
                  }, 'Exit'),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.8,
              ),
              Column(
                children: <Widget>[
                  functionText('Version', Colors.white, FontWeight.bold, 15),
                  functionText('1.0.0', Colors.white, FontWeight.bold, 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget functionText(
    String content, Color color, FontWeight weight, double fontSize) {
  return Text(
    content,
    style: TextStyle(
      color: color,
      fontWeight: weight,
      fontSize: fontSize,
    ),
  );
}

//text function
Widget functionTextButton(Function() textFunction, String text) {
  return TextButton(
    style: ButtonStyle(
        alignment: Alignment.centerLeft,
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.zero,
        )),
    onPressed: textFunction,
    child: functionText(
      text,
      Colors.white,
      FontWeight.bold,
      20,
    ),
  );
}

const String privacyPolicyContent =
    'At React Messenger, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by React Messenger and how we use it.If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.';
