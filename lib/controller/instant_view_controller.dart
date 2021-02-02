// https://api.readhub.cn/topic/instantview?topicId=830stGvr7uR

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/instant_view_model.dart';

class InstantViewController extends GetxController {
  String topicId;
  InstantViewController({this.topicId});

  Dio _dio;

  InstantViewModel instantViewModel = InstantViewModel();

  renewTopicId(String newTopicId) {
    this.topicId = newTopicId;
    _initModel();
  }

  _initModel() async {
    try {
      var param = {'topicId': topicId};
      var res = await _dio.get('/topic/instantview', queryParameters: param);
      if (res.statusCode == 200) {
        instantViewModel = InstantViewModel.fromJson(res.data);
      }
    } catch (e) {
      print(e.toString());
    }
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    BaseOptions options = BaseOptions(
      baseUrl: 'https://api.readhub.cn',
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );
    _dio = Dio(options);
    await _initModel();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _dio.close();
  }
}
