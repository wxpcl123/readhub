import 'package:dio/dio.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../models/search_model.dart';

// https://search.readhub.cn/api/entity/news?page=1&size=20&query=%E9%AB%98%E9%80%9A&type=hot

class SearchController extends GetxController {
  final String keyword;
  SearchController({this.keyword});

  /// 监控目标
  SearchData searchData = SearchData();

  /// 一次加载的数量
  int _size = 10;

  /// 类型: 热门话题, 还有一种'all', 我忽略它
  String type = 'hot';

  /// 记录总共的页数
  int _totalPages;

  /// 当前页码
  int _pageIndex;

  /// http
  Dio _dio;

  loadMore() async {
    try {
      if (_pageIndex >= _totalPages) return;
      var parameters = {
        'page': _pageIndex + 1,
        'size': _size,
        'query': keyword,
        'type': type,
      };
      var res = await _dio.get('/news', queryParameters: parameters);
      if (res.statusCode == 200) {
        SearchData tmpData = SearchData.fromJson(res.data['data']);
        if (tmpData != null) {
          _pageIndex = searchData.pageIndex;
          searchData.items.addAll(tmpData.items);
        }
      }
    } catch (e) {
      //
    }
    update();
  }

  /// 初始化, 加载若干搜索项
  _initModel() async {
    try {
      var parameters = {
        'page': 1,
        'size': _size,
        'query': keyword,
        'type': type,
      };
      var res = await _dio.get('/news', queryParameters: parameters);
      if (res.statusCode == 200) {
        searchData = SearchData.fromJson(res.data['data']);
        if (searchData != null) {
          _pageIndex = searchData.pageIndex;
          _totalPages = searchData.totalPages;
        }
      }
    } catch (e) {
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
