import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:submission_mydigilearn/model/image_response.dart';
import 'package:submission_mydigilearn/service/api_client.dart';

class ImageController extends GetxController {
  final Dio _client = ApiClient().init();

  var listImage = List<Meme>.empty().obs;

  Future<void> getImage() async {
    try {
      var response = await _client.get("/get_memes");
      ImageResponse data = ImageResponse.fromJson(response.data);
      listImage.addAll(data.data.memes);
    } on DioError catch (e) {
      Get.snackbar("ERROR", e.message.toString());
    }
  }

  @override
  void onInit() {
    getImage();
    super.onInit();
  }
}
