import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/topic_model.dart';
import '../common/functions.dart';
import '../screens/topic_details.dart';

/// 该Widget用于显示topic的简略视图
///
/// 默认状态下显示title和部分summary, 点击后summary显示完整
///
/// 本widget通过借鉴[Radio]的部分属性和方法, 将其同时改造成了具有radio属性的widget
///
/// - 可以设置[groupValue], 将多条[TopicItemView]串联起来
/// - 可以设置[value], 可以根据其是否与[groupValue]是否相同来判断是否被选中
///
class TopicItemView extends StatelessWidget {
  final TopicData topicData;

  /// 相当于radio的[value]
  final String value;

  /// 相当于Radio的[groupValue], 将其归入一个radio组中
  final String groupValue;

  /// 相当于Radio的[onChanged]
  final ValueChanged<String> onChanged;

  /// 相当于Radio的[toggleable], 即可以取消对自身的选中
  final bool toggleable;

  bool get checked => value == groupValue;

  const TopicItemView({
    Key key,
    this.topicData,
    this.value,
    this.groupValue,
    this.onChanged,
    this.toggleable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.only(bottom: 2),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(2),
            boxShadow: !checked
                ? []
                : [
                    BoxShadow(
                      color: Theme.of(context).secondaryHeaderColor,
                      offset: Offset(-0.5, -0.5),
                      // blurRadius: 2,
                      spreadRadius: 0.0,
                    ),
                    BoxShadow(
                      color: Theme.of(context).secondaryHeaderColor,
                      offset: Offset(0.5, 0.5),
                      // blurRadius: 2,
                      spreadRadius: 0.0,
                    ),
                  ],
          ),
          child: Column(
            children: [
              topicTitleView(context, topicData),
              topicContentView(context, topicData, checked),
            ],
          ),
        ),
      ),
    );
  }

  Widget topicTitleView(BuildContext context, TopicData topicData) {
    var titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    var topTitleStyle = TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).accentColor
            : Theme.of(context).primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w500);
    var createAtStyle = TextStyle(
      color: Theme.of(context).secondaryHeaderColor,
      fontWeight: FontWeight.w300,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: InkWell(
              onTap: () {
                print('go to TopicDetails(${topicData.id})');
                Get.to(TopicDetails(topicId: topicData.id));
              },
              child: Text(
                topicData.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: topicData.order > 1000000 ? topTitleStyle : titleStyle,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              timeAhead(DateTime.parse(topicData.createdAt)),
              style: createAtStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget topicContentView(
      BuildContext context, TopicData topicData, bool checked) {
    var summaryStyle = TextStyle(
        color: Theme.of(context).primaryColorDark,
        letterSpacing: 1.6,
        height: 1.7);
    if (!checked)
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
        child: Text(
          topicData.summary.trim(),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: summaryStyle,
        ),
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: Text(topicData.summary.trim(), style: summaryStyle),
        ),
      ],
    );
  }

  // end of class
}
