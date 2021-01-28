import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/functions.dart';
import '../models/search_model.dart';
import '../screens/topic_details.dart';

class SearchItemView extends StatelessWidget {
  final Item item;

  const SearchItemView({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = TextStyle(
      // color: Get.theme.primaryColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
    var deAccentStyle =
        TextStyle(color: Theme.of(context).secondaryHeaderColor);
    var summaryStyle = TextStyle(
        color: Theme.of(context).primaryColorDark,
        letterSpacing: 1.6,
        height: 1.7);
    return Container(
      color: Theme.of(context).backgroundColor,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => Get.to(TopicDetails(topicId: item.topicId)),
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Text(
                  '${item.topicTitle}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  timeAsDay(DateTime.parse('${item.topicCreateAt}')),
                  style: deAccentStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: Text(
                  '${item.topicSummary}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: summaryStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
