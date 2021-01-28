import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';

import '../widgets/menu.dart';
import '../widgets/share_topic.dart';
import '../widgets/my_dot.dart';
import '../common/functions.dart';
import '../controller/topic_details_controller.dart';
import '../controller/instant_view_controller.dart';
import '../models/topic_details_model.dart';
import '../screens/media_viewpage.dart';
import 'following_listview.dart';

class TopicDetails extends StatefulWidget {
  final String topicId;
  const TopicDetails({Key key, this.topicId}) : super(key: key);

  @override
  _TopicDetailsState createState() => _TopicDetailsState();
}

class _TopicDetailsState extends State<TopicDetails> {
  ScrollController scrollController;
  TopicDetailsController topicDetailsController;
  InstantViewController instantViewController;

  @override
  void initState() {
    super.initState();
    // 淡淡的style

    scrollController = ScrollController();
    topicDetailsController = Get.put<TopicDetailsController>(
        TopicDetailsController(topicId: widget.topicId),
        tag: widget.topicId);
    instantViewController = Get.put<InstantViewController>(
        InstantViewController(topicId: widget.topicId),
        tag: widget.topicId);
  }

  showShareContent(TopicDetailsModel detailsModel) {
    showDialog(
        context: context,
        builder: (context) => ShareTopic(detailsModel: detailsModel));
  }

  @override
  Widget build(BuildContext context) {
    if (topicDetailsController == null) {
      topicDetailsController =
          Get.put<TopicDetailsController>(TopicDetailsController());
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              showShareContent(topicDetailsController.topicDetailsModel);
            },
          ),
          SizedBox(width: 10),
          Menu(),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: GetBuilder<TopicDetailsController>(
          tag: widget.topicId,
          builder: (_) {
            var topicModel = topicDetailsController.topicDetailsModel;
            if (topicModel.newsArray == null)
              return Center(child: CupertinoActivityIndicator());
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle(topicModel.title),
                  buildTimeAndSource(
                      topicModel.createdAt, topicModel.hasInstantView),
                  buildContent(topicModel.summary, topicModel.hasInstantView),
                  buildEntityicButtons(topicModel.entityTopics),
                  buildMediaRelated(topicModel.newsArray),
                  buildTopicFollowing(topicModel.timeline),
                  SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// 标题
  Widget buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 创建时间和topic来源
  Widget buildTimeAndSource(String dateTime, bool hasInstantView) {
    TextStyle deAccentStyle =
        TextStyle(color: Theme.of(context).secondaryHeaderColor);
    var dtime = timeAhead(DateTime.parse(dateTime));
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(dtime, style: deAccentStyle),
          !hasInstantView
              ? Text('本站编辑')
              : GetBuilder<InstantViewController>(
                  tag: widget.topicId,
                  builder: (_) {
                    var instantViewModel =
                        instantViewController.instantViewModel;
                    if (instantViewModel.siteName == null) {
                      return CupertinoActivityIndicator();
                    }
                    return Text('来源: ${instantViewModel.siteName}',
                        style: deAccentStyle);
                  },
                ),
        ],
      ),
    );
  }

  /// 主内容
  Widget buildContent(String summary, bool hasInstantView) {
    var summaryStyle = TextStyle(fontSize: 16, letterSpacing: 1.6, height: 1.8);
    if (!hasInstantView) print('instantViewModel无数据, 使用原来topic对应的summary作为输出源');
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: !hasInstantView
          ? Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(summary, style: summaryStyle),
            )
          : GetBuilder<InstantViewController>(
              tag: widget.topicId,
              builder: (_) {
                var model = instantViewController.instantViewModel;
                if (model.content == null) {
                  return CupertinoActivityIndicator();
                }
                return Html(
                  data: model.content,
                  //Optional parameters:
                  style: {
                    "html": Style(
                        // backgroundColor: Colors.white,
                        fontSize: FontSize.large,
                        letterSpacing: 1.2),
                    "body": Style(lineHeight: 1.8),
                    "table": Style(
                        backgroundColor:
                            Color.fromARGB(0x50, 0xee, 0xee, 0xee)),
                    "tr": Style(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    "th": Style(
                        padding: EdgeInsets.all(6),
                        backgroundColor: Colors.grey),
                    "td": Style(padding: EdgeInsets.all(6)),
                    "p": Style(
                        margin: EdgeInsets.only(top: 25), lineHeight: 1.8),
                    "a": Style(color: Theme.of(context).accentColor),
                    // "var": Style(fontFamily: 'serif'),
                  },
                  customRender: {
                    "flutter":
                        (RenderContext context, Widget child, attributes, _) {
                      return CupertinoActivityIndicator();
                    },
                  },
                  onLinkTap: (url) {
                    print("Opening $url...");
                  },
                  onImageTap: (src) {
                    print(src);
                  },
                  onImageError: (exception, stackTrace) {
                    print(exception);
                  },
                );
              },
            ),
    );
  }

  /// 关键字
  Widget buildEntityicButtons(List<EntityTopic> entityTopics) {
    if (entityTopics == null || entityTopics.length <= 0) return Container();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(entityTopics.length + 1, (index) {
            return Container(
              padding: const EdgeInsets.only(right: 20),
              child: index == 0
                  ? Text('搜索:')
                  : OutlinedButton(
                      onPressed: () => Get.to(FollowingListView(
                          keyword: entityTopics[index - 1].entityName)),
                      child: Text(
                        entityTopics[index - 1].entityName,
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
            );
          }),
        ),
      ),
    );
  }

  /// 模块icon和描述
  Widget blockDesc(IconData icon, String desc) {
    var descStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).secondaryHeaderColor),
        SizedBox(width: 10),
        Text(desc, style: descStyle),
      ],
    );
  }

  /// 媒体报道
  Widget buildMediaRelated(List<News> newsArray) {
    TextStyle deAccentStyle =
        TextStyle(color: Theme.of(context).secondaryHeaderColor);
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          blockDesc(Icons.description, '媒体报道'),
          Divider(),
          Column(
            children: List.generate(
              newsArray.length,
              (index) {
                return InkWell(
                  onTap: () {
                    Get.to(MediaViewPage(
                      url: newsArray[index].mobileUrl,
                      title: newsArray[index].title,
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyDot(margin: EdgeInsets.only(top: 6, right: 10)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newsArray[index].title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10),
                              Text(newsArray[index].siteName,
                                  style: deAccentStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 话题相关:根据commonEntities是否存在, 决定是显示事件追踪还是关联事件
  Widget buildTopicFollowing(Timeline timeline) {
    if (timeline == null || timeline.topics == null) return Container();

    List<Topic> topics = timeline.topics;
    if (timeline.commonEntities.length == 0) {
      // 关联事件
      return buildTopicRelated(topics);
    } else {
      // 事件追踪
      return buildTopicTracker(topics);
    }
  }

  /// 关联事件
  Widget buildTopicRelated(List<Topic> topics) {
    TextStyle deAccentStyle =
        TextStyle(color: Theme.of(context).secondaryHeaderColor);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          blockDesc(Icons.library_books, '关联事件'),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              topics.length - 1,
              (index) => Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyDot(margin: EdgeInsets.only(top: 6, right: 10)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timeAsDay(
                                DateTime.parse(topics[index + 1].createdAt)),
                            style: deAccentStyle,
                          ),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              print('TopicId = ${topics[index + 1].id}');
                              topicDetailsController
                                  .renewTopicId(topics[index + 1].id);
                              instantViewController
                                  .renewTopicId(topics[index + 1].id);
                              scrollController.animateTo(0,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.bounceIn);
                            },
                            child: Text(
                              topics[index + 1].title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 事件追踪
  Widget buildTopicTracker(List<Topic> topics) {
    TextStyle deAccentStyle =
        TextStyle(color: Theme.of(context).secondaryHeaderColor);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          blockDesc(Icons.timeline, '事件追踪'),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    topics.length - 1,
                    (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyDot(),
                        if (index != topics.length - 2)
                          Container(
                            width: 1,
                            height: 47.2,
                            margin: EdgeInsets.only(left: 3.5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    topics.length - 1,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timeAsDay(
                                DateTime.parse(topics[index + 1].createdAt)),
                            style: deAccentStyle,
                          ),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              print('TopicId = ${topics[index + 1].id}');
                              if (widget.topicId == topics[index + 1].id)
                                return;
                              topicDetailsController
                                  .renewTopicId(topics[index + 1].id);
                              instantViewController
                                  .renewTopicId(topics[index + 1].id);
                              scrollController.animateTo(0,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.bounceIn);
                            },
                            child: Text(
                              topics[index + 1].title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
