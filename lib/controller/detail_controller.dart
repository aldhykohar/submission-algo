import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailController extends GetxController {
  var selectedIndex = 0.obs;
  var watermark = "".obs;
  final watermarkC = TextEditingController();

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void setWatermark(String text) {
    watermark.value = text;
  }
}
