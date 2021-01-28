import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets/menu.dart';
import '../models/search_model.dart';
import '../controller/search_controller.dart';
import '../widgets/search_item_view.dart';

class FollowingListView extends StatefulWidget {
  final String keyword;
  final bool needAppBar;

  const FollowingListView({Key key, this.keyword, this.needAppBar = true})
      : super(key: key);

  @override
  _FollowingListViewState createState() => _FollowingListViewState();
}

class _FollowingListViewState extends State<FollowingListView>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController;
  SearchController searchController;
  RefreshController refreshController;
  double offset = 0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          offset = scrollController.offset;
        });
      });
    searchController = Get.put<SearchController>(
        SearchController(keyword: widget.keyword),
        tag: widget.keyword);
    refreshController = RefreshController();
  }

  _onLoading() async {
    await searchController.loadMore();
    refreshController.loadComplete();
  }

  void _jump2Top() {
    scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: widget.needAppBar
          ? AppBar(
              title: Text(widget.keyword),
              centerTitle: false,
              actions: [Menu()],
            )
          : null,
      body: GetBuilder<SearchController>(
          tag: widget.keyword,
          builder: (_) {
            if (searchController.searchData.items == null)
              return Center(child: CupertinoActivityIndicator());
            List<Item> items = searchController.searchData.items;
            return SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              footer: ClassicFooter(),
              controller: refreshController,
              onLoading: _onLoading,
              child: ListView.builder(
                controller: scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return SearchItemView(item: items[index]);
                },
              ),
            );
          }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (scrollController != null)
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
