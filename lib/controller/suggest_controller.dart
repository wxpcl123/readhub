// https://search.readhub.cn/api/entity/suggest?q=h

import 'package:dio/dio.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../models/suggest_model.dart';

class SuggestController extends GetxController {
  List<String> suggestList = [];

  Dio _dio;

  //
  loadSuggest(String query) async {
    print('开始load Suggest, query = $query');
    // 先过滤一下
    // 1 - 若无输入, 返回空数组
    if (query.trim() == '' || query == null) {
      suggestList.clear();
      update();
      return;
    }

    try {
      var parameters = {
        'q': query,
      };
      var res = await _dio.get('/suggest', queryParameters: parameters);
      if (res.statusCode == 200) {
        // 2 - 若输入的query, 找不到suggest, 则不更新, 直接返回
        // 找不到suggest, 返回的是['data'], 正常应该返回['result']['data']
        // 若之前数组为空则返回空数组, 若之前数组有内容, 还是返回原数组
        if (res.data['data'] != null) {
          return;
        }
        // 3 - 能get到suggest, 则解析, 更新数组
        var data = res.data['result']['data'];
        SuggestData suggestData = SuggestData.fromJson(data);
        suggestList.clear();
        suggestData.items.forEach((item) {
          suggestList.add(item.text);
        });
        print('${suggestList.toString()}');
      }
    } catch (e) {
      //
      print('${e.toString()}');
    }
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    BaseOptions options = BaseOptions(
      baseUrl: 'https://search.readhub.cn/api/entity',
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
      connectTimeout: 3000,
      receiveTimeout: 3000,
    );
    _dio = Dio(options);
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
