import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets/loading.dart';
import '../widgets/topic_item_view.dart';
import '../controller/topic_controller.dart';

class TopicScreen extends StatefulWidget {
  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  //
  TopicController topicController;

  //
  ScrollController scrollController;
  double offset = 0;
  //
  RefreshController refreshController;
  //
  String groupValue = '';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    print('Topic--->App Status: $state');

    if (state == AppLifecycleState.resumed) {
      topicController = Get.find<TopicController>();
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          offset = scrollController.offset;
        });
      });
    WidgetsBinding.instance.addObserver(this);
    topicController = Get.put(TopicController(), permanent: true);
    refreshController = RefreshController();
  }

  void _onRefresh() async {
    if (topicController == null) {
      topicController = Get.find<TopicController>();
    }
    await topicController.updateMoreTopic();
    refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (topicController == null) {
      topicController = Get.find<TopicController>();
    }
    await topicController.loadMoreTopics();
    refreshController.loadComplete();
  }

  void _jump2Top() {
    scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController?.dispose();
    refreshController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GetBuilder<TopicController>(builder: (_) {
        if (topicController.topics.length == 0)
          return Loading(onTap: topicController.onError);
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: ClassicHeader(),
          footer: ClassicFooter(),
          controller: refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            controller: scrollController,
            itemCount: topicController.topics.length,
            itemBuilder: (context, index) {
              var topicData = topicController.topics[index];
              return TopicItemView(
                topicData: topicData,
                value: topicData.id,
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
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (offset > 540)
            FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              onPressed: _jump2Top,
              tooltip: 'jump',
              child: Icon(Icons.arrow_upward_outlined),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
