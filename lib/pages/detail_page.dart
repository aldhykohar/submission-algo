import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:submission_mydigilearn/controller/detail_controller.dart';

import '../widgets/custom_button.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final detailC = Get.put(DetailController());

  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  String? imgBase64;

  Future pickImage(String type) async {
    ImageSource source;
    switch (type) {
      case "Camera":
        source = ImageSource.camera;
        break;
      case "Gallery":
        source = ImageSource.gallery;
        break;
      default:
        return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 480,
        maxHeight: 480,
        imageQuality: 50,
      );
      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
          final bytes = _imageFile!.readAsBytesSync();
          imgBase64 = base64Encode(bytes);
          print(imgBase64);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("image_watermark"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                Get.arguments.toString(),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            FittedBox(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    button(text: "Image", index: 0),
                    button(text: "Text", index: 1),
                  ],
                ),
              ),
            ),
            Obx(
              () => Container(
                child: detailC.selectedIndex.value == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            title: "Select Image",
                            onPress: () => pickImage("Gallery"),
                          ),
                          const SizedBox(width: 8),
                          CustomButton(
                            title: "Take Image",
                            onPress: () => pickImage("Camera"),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          CustomButton(
                            title: "Add Watermark",
                            onPress: () => detailC.setWatermark(
                              detailC.watermarkC.text.toString(),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: TextFormField(
                              controller: detailC.watermarkC,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    Get.arguments.toString(),
                    fit: BoxFit.contain,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: _imageFile == null
                            ? Container()
                            : Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Obx(
                        () => Text(
                          detailC.watermark.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget button({required String text, required int index}) {
    return Obx(
      () => InkWell(
        splashColor: Colors.cyanAccent,
        onTap: () => detailC.updateSelectedIndex(index),
        child: Container(
          padding: const EdgeInsets.all(12),
          color:
              index == detailC.selectedIndex.value ? Colors.blue : Colors.white,
          child: Text(
            text,
            style: TextStyle(
              color: index == detailC.selectedIndex.value
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
