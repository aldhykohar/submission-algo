import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:submission_mydigilearn/controller/detail_controller.dart';
import 'package:submission_mydigilearn/pages/preview_page.dart';

import '../widgets/custom_button.dart';

import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final detailC = Get.put(DetailController());

  final ImagePicker _picker = ImagePicker();

  String? _imageUri;
  File? _imageFile;
  File? _imageResult;
  Uint8List? _imgMemory;
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

  Future<void> takeScreenshot() async {
    final controller = ScreenshotController();
    final bytes = await controller.captureFromWidget(Material(
      child: buildCanvas(),
    ));
    setState(() => _imgMemory = bytes);
  }

  @override
  void initState() {
    super.initState();
    setState(() => _imageUri = Get.arguments.toString());
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
            buildCanvas(),
            const SizedBox(height: 16),
            CustomButton(
              title: "NEXT",
              onPress: () async {
                await takeScreenshot();
                Get.to(() => const PreviewPage(), arguments: _imgMemory);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCanvas() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            _imageUri!,
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
