import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        centerTitle: true,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1667328011998-b7556ca3a5af?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80'),
              ),
              title: const Text('Username'),
              subtitle: const Text('data'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                ElevatedButton(onPressed: () {}, child: const Text('Remove')),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Block'))
              ]),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(),
          itemCount: 10),
    );
  }
}
