import 'package:flutter/material.dart';
import 'package:flutter_application_1/sidebar/sidebar_controller.dart';
import 'package:get/get.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late SideBarController sideBarController;

  @override
  void initState() {
    super.initState();
    sideBarController = Get.put(SideBarController());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      width: 250, // Set the height of the sidebar to occupy the full height of the screen
      decoration: const BoxDecoration(
        color: Color(0xFFCDE9C8), // Set the background color of the sidebar
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30), // Give a curved shape to the top-right corner
          bottomRight: Radius.circular(30), // Give a curved shape to the bottom-right corner
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make the scaffold background transparent
        body: Padding(
          padding: const EdgeInsets.only(top: 50), // Adjust the top padding to shift the sidebar upwards more
          child: ListView(
            children: const [
              ListTile(
                leading: Icon(Icons.chat_bubble_outline),
                title: Text('New Chat +'),
              ),
              ListTile(
                leading: Icon(Icons.star_border_outlined),
                title: Text('Starred Messages'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
