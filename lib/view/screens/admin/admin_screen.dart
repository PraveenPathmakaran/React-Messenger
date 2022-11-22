import 'package:flutter/material.dart';
import 'package:react_messenger/const/colors.dart';

import '../../../widgets/widgets.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Admin',
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: const CircleAvatarWidget(
                networkImagePath:
                    'https://images.unsplash.com/photo-1667328011998-b7556ca3a5af?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
              ),
              title: const Text('Username'),
              subtitle: const Text('data'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                ElevatedButton(onPressed: () {}, child: const Text('Remove')),
                kHeight10,
                ElevatedButton(onPressed: () {}, child: const Text('Block'))
              ]),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(),
          itemCount: 10),
    );
  }
}
