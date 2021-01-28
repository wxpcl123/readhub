// https://api.readhub.cn/news?pageSize=10&lastCursor=xxxxxx
// https://api.readhub.cn/technews?pageSize=10&lastCursor=xxxxxx
// https://api.readhub.cn/blockchain?pageSize=10&lastCursor=xxxxxx

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../common/functions.dart';
import '../models/news_model.dart';

/// 根据newsType生成不同的Controller,
/// 三种newsType分别是:
/// - [news]
/// - [technews]
/// - [blockchain]
class NewsController extends GetxController {
  final String newsType;
  NewsController({this.newsType = '/news'});

  List<NewsData> newsDatas = [];

  /// http
  Dio _dio;

  /// 一次加载news的数量
  int _pageSize = 20;

  /// 最后一个publishDate, 用于上拉加载的参数
  String _lastCursor = '';

  /// 第一个publishDate, 用于对照下拉刷新的数据
  String _firstCursor = '';

  /// 启动时若无网络, 或无法获取到信息, 可再次点击初始化
  onError() {
    newsDatas.clear();
    _firstCursor = '';
    _lastCursor = '';
    _initNews();
  }

  /// 下拉刷新
  /// 检查加载的列表里是否部分是新增加的, 还是说都是新增加的, 甚至还要递补更多
  updateMoreNews() async {
    try {
      var queryParameters = {'pageSize': _pageSize};
      var res = await _dio.get(newsType, queryParameters: queryParameters);
      if (res.statusCode == 200) {
        var tmpNewsDatas = NewsModel.fromJson(res.data).newsDatas;
        //
        if (tmpNewsDatas != null) {
          List<String> cursors = [];
          tmpNewsDatas.forEach((element) {
            cursors.add(element.publishDate);
          });
          // 判断, 不更新, 或只更新部分
          if (cursors.contains(_firstCursor)) {
            newsDatas.insertAll(
                0, tmpNewsDatas.sublist(0, cursors.indexOf(_firstCursor)));

            print('增加了${cursors.indexOf(_firstCursor)}条news, 加载到前面去');
            if (cursors.indexOf(_firstCursor) > 0) {
              showSnack('成功', '更新了${cursors.indexOf(_firstCursor)}条新闻');
            }

            _firstCursor = cursors.first;
          } else {
            // 这些全都是最近更新的, 但还要看有没有已更新但没加载的, 全都加载进来
            while (_firstCursor != tmpNewsDatas.last.publishDate) {
              var lastCursor = DateTime.parse(tmpNewsDatas.last.publishDate)
                  .millisecondsSinceEpoch
                  .toString();
              var parameters = {'pageSize': '1', 'lastCursor': lastCursor};
              var res = await _dio.get(newsType, queryParameters: parameters);
              if (res.statusCode == 200) {
                var oneNewsData = NewsModel.fromJson(res.data).newsDatas.first;
                if (oneNewsData.publishDate == _firstCursor) break;
                tmpNewsDatas.add(oneNewsData);
              }
            }
            // 全部加载进去, 放在前面
            newsDatas.insertAll(0, tmpNewsDatas);
            _firstCursor = cursors.first;

            print('全是新的news, 数量${cursors.length}条,加载到前面去');
            showSnack('成功', '更新了${cursors.length}条新闻');
          }
        }
      } else {
        print('Upgrade更新: dio error status = ${res.statusCode}');
        showSnack('网络错误', '下拉刷新时遇到服务端故障, 故障代号: ${res.statusCode}');
      }
    } catch (e) {
      print('${e.toString()}');
      showSnack('错误', 'Upgrade更新: ${e.toString()}');
    }
    update();
  }

  /// 上拉加载更多, 加载若干更早的news
  loadMoreNews() async {
    try {
      var queryParameters = {'pageSize': _pageSize, 'lastCursor': _lastCursor};
      var res = await _dio.get(newsType, queryParameters: queryParameters);
      if (res.statusCode == 200) {
        var tmpNewsDatas = NewsModel.fromJson(res.data).newsDatas;
        if (tmpNewsDatas != null) {
          newsDatas.addAll(tmpNewsDatas);
          _lastCursor = DateTime.parse(newsDatas.last.publishDate)
              .millisecondsSinceEpoch
              .toString();
          print('加载了$_pageSize条news');
        }
      } else {
        print('上拉加载更多时遇到服务端故障, 故障代号: ${res.statusCode}');
        showSnack('网络错误', '上拉加载更多时遇到服务端故障, 故障代号: ${res.statusCode}');
      }
    } catch (e) {
      print('${e.toString()}');
      showSnack('错误', 'LoadMore加载: ${e.toString()}');
    }
    update();
  }

  /// 页面激活时加载一定数量的news
  Future _initNews() async {
    try {
      var queryParameters = {'pageSize': _pageSize};
      var res = await _dio.get(newsType, queryParameters: queryParameters);
      if (res.statusCode == 200) {
        newsDatas = NewsModel.fromJson(res.data).newsDatas;
        _lastCursor = DateTime.parse(newsDatas.last.publishDate)
            .millisecondsSinceEpoch
            .toString();
        _firstCursor = newsDatas.first.publishDate;
      }
    } catch (e) {
      print('${e.toString()}');
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    BaseOptions options = BaseOptions(
      baseUrl: 'https://api.readhub.cn',
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
    _initNews();
  }

  @override
  void onClose() {
    super.onClose();
    _dio?.close();
  }
}
