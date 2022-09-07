import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:submission_mydigilearn/controller/image_controller.dart';
import 'package:submission_mydigilearn/pages/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imageC = Get.find<ImageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GridView"),
      ),
      body: Obx(() => RefreshIndicator(
            onRefresh: () => refreshData(),
            child: GridView.count(
              crossAxisCount: 2,
              children: imageC.listImage
                  .map(
                    (value) => GestureDetector(
                      onTap: () => Get.to(() => const DetailPage(),
                          arguments: value.url),
                      child: Image.network(
                        value.url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  .toList(),
            ),
          )),
    );
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    imageC.listImage.clear();
    imageC.getImage();
  }
}
