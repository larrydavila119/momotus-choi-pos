import 'package:choi_pos/widgets/sidebar_admin.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SidebarAdmin()
              ],
            ),
          ),
          Center(
            child: Text('General'),
          )

        ],
      ),
    );
  }
}