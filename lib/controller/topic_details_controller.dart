// https://api.readhub.cn/topic/topicId

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/topic_details_model.dart';

class TopicDetailsController extends GetxController {
  String topicId;
  TopicDetailsController({this.topicId});

  /// 需要监听的主数据
  TopicDetailsModel topicDetailsModel = TopicDetailsModel();

  Dio _dio;

  /// 更新topicId, 以便更新details的内容
  renewTopicId(String nTopicId) {
    this.topicId = nTopicId;
    _initModel();
  }

  _initModel() async {
    try {
      print('/topic/$topicId');
      var res = await _dio.get('/topic/$topicId');
      if (res.statusCode == 200) {
        topicDetailsModel = TopicDetailsModel.fromJson(res.data);
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
