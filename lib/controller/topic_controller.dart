// https://api.readhub.cn/topic?pageSize=10&lastCursor=xxxxxx

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../common/functions.dart';
import '../models/topic_model.dart';

class TopicController extends GetxController {
  /// 监控的主要目标
  List<TopicData> topics = [];

  /// 置顶topic列表
  List<TopicData> _topTopics = [];

  /// 普通topic列表
  List<TopicData> _normalTopics = [];

  /// http
  Dio _dio;

  /// 一次加载topic的数量
  int _pageSize = 20;

  /// 第[0]个order, refresh更新topic时的参照
  String _firstOrder = '';

  /// 最后一个order, 用于上拉加载的参数
  String _lastCursor = '';

  /// 添加2条假的topic, 用于测试刷新时, 是否会将它们剔除掉
  addFakeTopics() {
    var fake1 = _normalTopics.last;
    fake1.id = 'not_existed_01';
    fake1.title = '假的Topic Title 01';
    fake1.order = fake1.order + 105;

    var fake2 = _normalTopics[8];
    fake2.id = 'not_existed_02';
    fake2.title = '假的Topic Title 02';
    fake2.order = fake2.order + 210;

    _normalTopics.insert(0, fake1);
    topics.insert(_topTopics.length, fake1);
    _normalTopics.insert(0, fake2);
    topics.insert(_topTopics.length, fake2);

    _firstOrder = _normalTopics.first.order.toString();

    update();
  }

  /// 启动时若无网络, 或无法获取到信息, 可再次点击初始化
  onError() {
    print('Error occors, init again.');
    topics.clear();
    _topTopics.clear();
    _normalTopics.clear();
    _firstOrder = '';
    _lastCursor = '';
    _initTopics();
  }

  /// 检查第一条topic是否被删除了, 若被删除, 则下拉刷新的参照依据就没了, 需要替换
  Future<bool> _checkFirstAlive() async {
    try {
      if (_dio == null) _initDio();
      var res = await _dio.get('/topic/${_normalTopics.first.id}');

      if (res.statusCode == 200) {
        int count = 0;
        // 最顶的一条topic被删除, 则res.data == null || res.data == {}
        while (res.data.toString().length <= 4) {
          print('最顶的一条topic被删除了, :( ,挑选下面一条topic的order作为下拉刷新的依据');
          _normalTopics.removeAt(0);
          _firstOrder = _normalTopics.first.order.toString();
          topics.removeAt(_topTopics.length);
          count += 1;
          res = await _dio.get('/topic/${_normalTopics.first.id}');
          if (res.statusCode != 200) return false;
        }

        update();
        print('第一条topic检查完毕! 总共删除了$count条Topic, 可以继续');
        // showSnack('检查', '第一条topic检查完毕! 总共删除了$count条Topic, 可以继续');
        return true;
      } else {
        print('检测First: dio error status = ${res.statusCode}');
        showSnack('网络错误', '下拉检查时遇到服务端故障, 故障代号: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('检测First: ${e.toString()}');
      showSnack('错误', '可能网络不通, 或者服务器有问题, 无法更新.');
      return false;
    }
  }

  /// 下拉刷新
  /// - 1, 首先检测_firstOrder对应的topic是否被删除了, 若被删除需要找下一条做基准
  /// - 2, 检查加载的[_pageSize]条topic里是否有置顶项
  /// - 3, 检查普通topic里是否部分是新增加的, 还是说都是新增加的, 甚至还要递补更多
  updateMoreTopic() async {
    if (!await _checkFirstAlive()) return;

    try {
      print('完成_firstOrder的检查, 现在加载若干topic来看看');
      var res =
          await _dio.get('/topic', queryParameters: {'pageSize': '$_pageSize'});

      print('statuscode= ${res.statusCode}');
      if (res.statusCode == 200) {
        if (res.data == null) {
          showSnack('错误', '获取到的话题有错误, 也可能服务器提供的数据有错误');
          return;
        }
        var tmpTopics = TopicModel.fromJson(res.data).topicDatas;

        List<String> orderList = [];
        // 取消置顶
        // 若新拉取的第一个topic不为置顶的话, 说明官方将置顶清空了, 我们也要清空置顶
        if (tmpTopics.first.order < 1000000) {
          topics.removeRange(0, _topTopics.length);
          _topTopics.clear();
        }

        // 检查里面是否有置顶内容(order>1,000,000, 普通topic的order只有6位数), 有的话, 检查一下加入到_topTopics里
        // 没有置顶内容, 则准备检查到底有多少条更新项

        tmpTopics.forEach((topicData) {
          if (topicData.order > 1000000) {
            // 有置顶内容也要看下是否已包含了
            bool included = false;
            _topTopics.forEach((topTopic) {
              if (topTopic.id == topicData.id) {
                included = true;
              }
            });
            if (!included) {
              _topTopics.insert(0, topicData);
              topics.insert(0, topicData);
            }
          } else {
            orderList.add(topicData.order.toString());
          }
        });

        // 后面都是普通topic
        tmpTopics = tmpTopics.sublist(tmpTopics.length - orderList.length);

        // 如果:
        // 1-刷新太频繁, 可能只有部分(>=0个)topic是新增加的
        if (orderList.contains(_firstOrder)) {
          _normalTopics.insertAll(
              0, tmpTopics.sublist(0, orderList.indexOf(_firstOrder)));
          topics.insertAll(_topTopics.length,
              tmpTopics.sublist(0, orderList.indexOf(_firstOrder)));

          print('增加了${orderList.indexOf(_firstOrder)}条topic, 加载到前面去');
          if (orderList.indexOf(_firstOrder) > 0) {
            showSnack('成功', '更新了${orderList.indexOf(_firstOrder)}条topic');
          }

          _firstOrder = _normalTopics.first.order.toString();
        } else {
          // 2-很长时间没刷新了, 这次加载的topic全都是最近更新的, 但还要看有没有已更新但没加载的, 全都加载进来
          while (_firstOrder != tmpTopics.last.order.toString()) {
            var para = {'pageSize': '1', 'lastCursor': tmpTopics.last.order};
            var res = await _dio.get('/topic', queryParameters: para);
            if (res.statusCode == 200) {
              if (res.data == null) {
                // 若某项topic没加载出来, 可能网络原因, 或服务器问题, 那就不管它了, break跳出循环
                break;
              } else {
                var oneTopic = TopicModel.fromJson(res.data).topicDatas.first;
                if (oneTopic.order.toString() == _firstOrder) break;
                tmpTopics.add(oneTopic);
              }
            }
          }
          _normalTopics.insertAll(0, tmpTopics);
          topics.insertAll(_topTopics.length, tmpTopics);
          _firstOrder = _normalTopics.first.order.toString();
          print('全是新的topic, 数量${tmpTopics.length}条,加载到前面去');
          showSnack('成功', '更新了${tmpTopics.length}条topic');
        }
      } else {
        print('Upgrade更新: dio error status = ${res.statusCode}');
        showSnack('网络错误', '下拉刷新时遇到服务端故障, 故障代号: ${res.statusCode}');
      }
    } catch (e) {
      print('Upgrade更新: ${e.toString()}');
      showSnack('错误', 'Upgrade更新: ${e.toString()}');
    }
    update();
  }

  /// 检查最后一条topic是否被删除了, 若被删除, 则上拉加载更多的参照依据就没了, 需要替换
  _checkLastAlive() async {
    try {
      var res = await _dio.get('/topic/${_normalTopics.last.id}');
      if (res.statusCode == 200) {
        int count = 0;
        while (res.data == null) {
          print('最后一条topic被删除了, :( ,挑选倒数第二条topic的order作为拉加载更多的依据');
          _normalTopics.removeLast();
          topics.removeLast();
          _lastCursor = _normalTopics.last.order.toString();
          count += 1;
        }
        update();
        print('最后一条topic检查完毕! 总共删除了$count条Topic, 可以继续');
        // showSnack('检查', '最后一条topic检查完毕! 总共删除了$count条Topic, 可以继续');
        return true;
      } else {
        print('检测Last: dio error status = ${res.statusCode}');
        showSnack('网络错误', '上拉检查时遇到服务端故障, 故障代号: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('检测Last: ${e.toString()}');
      showSnack('错误', '可能网络不通, 或者服务器有问题, 无法更新.');
      return false;
    }
  }

  /// 上拉加载更多, 加载若干更早的topic
  loadMoreTopics() async {
    if (!await _checkLastAlive()) return;
    try {
      var parameters = {'pageSize': '$_pageSize', 'lastCursor': _lastCursor};
      var res = await _dio.get('/topic', queryParameters: parameters);
      if (res.statusCode == 200) {
        if (res.data == null) return;
        // 新加载的topic全部添加在后面
        var tmpTopics = TopicModel.fromJson(res.data).topicDatas;
        _normalTopics.addAll(tmpTopics);
        topics.addAll(tmpTopics);

        /// 更新[_lastCursor]
        _lastCursor = _normalTopics.last.order.toString();

        print('加载了$_pageSize条topic');
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

  /// 页面激活时加载一定数量的topic
  _initTopics() async {
    try {
      var parameters = {'pageSize': '$_pageSize'};
      var res = await _dio.get('/topic', queryParameters: parameters);
      if (res.statusCode == 200) {
        var topicModel = TopicModel.fromJson(res.data);
        var tmpTopics = topicModel.topicDatas;
        // 置顶的topic加入到_topTopics列表中
        tmpTopics.forEach((topicData) {
          if (topicData.order > 1000000) {
            _topTopics.add(topicData);
          }
        });
        // 非置顶的topic加入到_normalTopics中
        _normalTopics.addAll(tmpTopics.sublist(_topTopics.length));
        // 更新_lastCursor和_firstOrder
        _lastCursor = _normalTopics.last.order.toString();
        _firstOrder = _normalTopics.first.order.toString();
        // 重新组合后更新
        topics.addAll(_topTopics);
        topics.addAll(_normalTopics);
      } else {
        showSnack('网络错误', '初始化时发生网络错误, 错误代码:${res.statusCode}');
      }
    } catch (e) {
      print('${e.toString()}');
      //showSnack('错误', 'Init初始化: ${e.toString()}');
    }
    update();
  }

  _initDio() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://api.readhub.cn',
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
      connectTimeout: 5000,
      receiveTimeout: 5000,
    );
    _dio = Dio(options);
  }

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  @override
  void onReady() async {
    super.onReady();
    await _initTopics();
  }

  @override
  void onClose() {
    super.onClose();
    _dio?.close();
  }
}
