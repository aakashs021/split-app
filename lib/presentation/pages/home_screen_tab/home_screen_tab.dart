import 'package:demo/presentation/controllers/home_screen_tab_controller.dart/home_screen_tab_controller_getx.dart';
import 'package:demo/presentation/pages/group_screen/group_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/presentation/pages/home_page/home_screen.dart';

class HomeScreenTabBar extends StatelessWidget {
  const HomeScreenTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final TabControllerX tabControllerX = Get.put(TabControllerX());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        bottom: TabBar(
          controller: tabControllerX.tabController,
          indicatorColor: Colors.blue, // Blue indicator for active tab
          labelColor: Colors.blue, // Active tab color
          unselectedLabelColor: Colors.grey.shade500, // Inactive tab color
          labelPadding: EdgeInsets.symmetric(
              horizontal:
                  MediaQuery.of(context).size.width * 0.1), // Dynamic spacing
          labelStyle: const TextStyle(fontSize: 16), // Text size
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8), // Space between icon and text
                  Text('Friends'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group),
                  SizedBox(width: 8), // Space between icon and text
                  Text('Groups'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Obx(() => IndexedStack(
            index: tabControllerX.selectedIndex.value, // Switch between tabs
            children: const [
              HomeScreen(), // HomeScreen will not rebuild
              GroupScreen()
            ],
          )),
    );
  }
}

