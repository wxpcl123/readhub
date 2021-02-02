import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets/loading.dart';
import '../controller/news_controller.dart';
import '../widgets/news_item_view.dart';

/// 各种NewsScreen的基类, 只需要输入newsType和tag即可分出不同的实例
/// - newsType, 用于区分科技动态,技术资讯和区块链等
/// - tag, 根据它可以分出不同的NewsController实例
class XNewsScreen extends StatefulWidget {
  final String newsType;
  final String tag;
  const XNewsScreen({Key key, @required this.newsType, @required this.tag})
      : super(key: key);

  @override
  _XNewsScreenState createState() => _XNewsScreenState();
}

class _XNewsScreenState extends State<XNewsScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  NewsController newsController;
  RefreshController refreshController;
  ScrollController scrollController;
  double offset = 0;
  //
  String groupValue = '';

  /// 下拉刷新
  _onRefresh() async {
    if (newsController.newsDatas != null) {
      await newsController.updateMoreNews();
    }
    refreshController.refreshCompleted();
  }

  /// 上拉加载更多
  _onLoading() async {
    if (newsController.newsDatas != null) {
      await newsController.loadMoreNews();
    }
    refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    newsController = Get.put(
      NewsController(newsType: widget.newsType),
      permanent: true,
      tag: widget.tag,
    );
    refreshController = RefreshController();
    scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          offset = scrollController.offset;
        });
      });

    WidgetsBinding.instance.addObserver(this);
  }

  /// 跳到顶部
  void jump2Top() {
    if (scrollController != null) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    refreshController?.dispose();
    scrollController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('${widget.newsType}--->App Status: $state');

    //
    if (state == AppLifecycleState.resumed) {
      newsController = Get.find<NewsController>(tag: widget.tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GetBuilder<NewsController>(
        tag: widget.tag,
        builder: (_) {
          if (newsController.newsDatas.length == 0)
            return Loading(onTap: newsController.onError);
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: refreshController,
            header: ClassicHeader(),
            footer: ClassicFooter(),
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView.builder(
              controller: scrollController,
              itemCount: newsController.newsDatas.length,
              itemBuilder: (context, index) {
                var newsData = newsController.newsDatas[index];
                return NewsItemView(
                  newsData: newsData,
                  value: newsData.id.toString(),
                  groupValue: groupValue,
                  toggleable: true,
                  onChanged: (value) {
                    setState(() {
                      groupValue = value;
                    });
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: offset < 500
          ? Container()
          : FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(Icons.arrow_upward),
              onPressed: jump2Top,
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
