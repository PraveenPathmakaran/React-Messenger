// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:react_messenger/controller/report_controller.dart';
// import 'package:react_messenger/controller/user_controller.dart';

// showAlertDialogue(BuildContext context, Map<String, dynamic> postdata) {
//   ReportController reportController = Get.put(ReportController());
//   UserController userController = Get.put(UserController());
//   //set up the buttons
//   Widget cancelButton = TextButton(
//       onPressed: () {
//         Get.back();
//       },
//       child: const Text('Cancel'));
//   Widget conformButton = TextButton(
//       onPressed: () {
//         reportController.postReport(postdata['postId'], postdata['uid'],
//             userController.userData.value!.uid,);
//       },
//       child: const Text('Confirm'));
//   //setup thealert dialogue

//   AlertDialog alert = AlertDialog(
//     title: const Text('Enter the report reason'),
//     content: TextField(
//       controller: reportController.reportTextEditingController,
//       decoration: const InputDecoration(hintText: 'Please enter reason'),
//     ),
//     actions: [cancelButton, conformButton],
//   );

//   //show dialogue

//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       });
// }
