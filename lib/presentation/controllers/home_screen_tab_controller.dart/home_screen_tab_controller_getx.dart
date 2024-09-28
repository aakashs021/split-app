import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabControllerX extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedIndex.value = tabController.index; // Update index on tab change
    });
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
