import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/news_model.dart';
import '../common/functions.dart';
import '../screens/media_viewpage.dart';

/// 该Widget用于显示topic的简略视图
///
/// 默认状态下显示title和部分summary, 点击后summary显示完整
///
/// 本widget通过借鉴[Radio]的部分属性和方法, 将其同时改造成了具有radio属性的widget
///
/// - 可以设置[groupValue], 将多条[TopicItemView]串联起来
/// - 可以设置[value], 可以根据其是否与[groupValue]是否相同来判断是否被选中
///
class NewsItemView extends StatelessWidget {
  final NewsData newsData;

  /// 相当于radio的[value]
  final String value;

  /// 相当于Radio的[groupValue], 将其归入一个radio组中
  final String groupValue;

  /// 相当于Radio的[onChanged]
  final ValueChanged<String> onChanged;

  /// 相当于Radio的[toggleable], 即可以取消对自身的选中
  final bool toggleable;

  const NewsItemView(
      {Key key,
      this.newsData,
      this.value,
      this.groupValue,
      this.onChanged,
      this.toggleable})
      : super(key: key);

  bool get checked => value == groupValue;

  @override
  Widget build(BuildContext context) {
    String summary = newsData.summary.trim().isEmpty
        ? '无摘要, 请查看详细内容.'
        : newsData.summary.trim();
    var titleStyle = TextStyle(
        // color: Theme.of(context).primaryColorLight,
        fontSize: 16,
        fontWeight: FontWeight.w500);
    var summaryStyle = TextStyle(
        color: Theme.of(context).primaryColorDark,
        letterSpacing: 1.6,
        height: 1.7);
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onChanged == null
          ? null
          : () {
              /// 已选中状态下, 取消自身的选中
              if (toggleable && checked) {
                onChanged(null);
                return;
              }

              /// 将[value]传递出去, 判断是否选中
              if (!checked) {
                onChanged(value);
              }
            },
      child: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(bottom: 1),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(2),
            boxShadow: checked
                ? [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(-0.5, -0.5),
                      // blurRadius: 5,
                      spreadRadius: 0.0,
                    ),
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0.5, 0.5),
                      // blurRadius: 5,
                      spreadRadius: 0.0,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  String url = newsData.mobileUrl;
                  print('$url');
                  Get.to(MediaViewPage(url: url, title: newsData.title));
                },
                child: Text(
                  newsData.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle,
                ),
              ),
              SizedBox(height: 15.0),
              checked
                  ? Text(summary, style: summaryStyle)
                  : Text(
                      summary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: summaryStyle,
                    ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Text(
                    newsData.siteName,
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(width: 20),
                  Text(
                    timeAhead(DateTime.parse(newsData.publishDate)),
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
