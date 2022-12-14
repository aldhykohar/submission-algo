import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../widgets/custom_button.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final controller = ScreenshotController();
  Uint8List? _imageUri;

  @override
  void initState() {
    super.initState();
    setState(() => _imageUri = Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> save() async {
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(_imageUri!);
      final path = await GallerySaver.saveImage(file.path);
      return path ?? false;
    }

    Future<void> shareFile() async {
      final tempDir = await getExternalStorageDirectory();
      File file = await File('${tempDir?.path}/image.png').create();
      file.writeAsBytes(_imageUri!);

      await FlutterShare.shareFile(
        filePath: file.path, title: 'Image',
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          _imageUri == null ? Container() : buildImage(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: "Save To Gallery",
                    onPress: () => save().then((value) {
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Image Saved'),
                          ),
                        );
                      }
                    }),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: CustomButton(
                    title: "Share",
                    onPress: () => shareFile(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildImage() => Image.memory(_imageUri!);
}
