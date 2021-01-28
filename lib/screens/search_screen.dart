import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/suggest_controller.dart';
import 'following_listview.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //
  TextEditingController textController;
  String get query => textController.text;
  set query(String value) {
    assert(query != null);
    textController.text = value;
  }

  //
  FocusNode focusNode;
  // bool hasFocus;
  //
  var suggestCtrl;
  List<String> recentSuggest = ['华为', '苹果', '特斯拉'];

  //

  @override
  void initState() {
    super.initState();
    textController = TextEditingController()..addListener(_onQueryChanged);
    focusNode = FocusNode()..addListener(_onFocusChanged);
    // hasFocus = true;
    suggestCtrl = Get.put<SuggestController>(SuggestController());
  }

  // rebuild ourselves because query changed.
  void _onQueryChanged() {
    setState(() {});
  }

  void _onChanged(String value) {
    print('$value');
    suggestCtrl.loadSuggest(value);
  }

  void _onSubmitted(String value) {
    focusNode.unfocus();
    // showSearch result
    Get.to(FollowingListView(keyword: query));
  }

  void _onFocusChanged() {
    setState(() {});
  }

  Widget buildQueryView() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: textController,
        focusNode: focusNode,
        autofocus: true,
        textInputAction: TextInputAction.search,
        onChanged: _onChanged,
        onSubmitted: _onSubmitted,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 7),
          border: InputBorder.none,
          hintText: '搜点啥?',
        ),
      ),
    );
  }

  buildActions() {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.trim() == '') Get.back();
          query = '';
        },
      ),
    ];
  }

  buildSuggestListView(List<String> suggests) {
    return ListView.builder(
      itemCount: suggests.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggests[index]),
          onTap: () {
            query = suggests[index];
            focusNode.unfocus();
            Get.to(FollowingListView(
              keyword: suggests[index],
            ));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: buildQueryView(),
        actions: buildActions(),
      ),
      body: GetBuilder<SuggestController>(
        builder: (_) {
          List<String> suggests;
          if (suggestCtrl.suggestList == null ||
              suggestCtrl.suggestList.length == 0) {
            suggests = recentSuggest;
          } else {
            suggests = suggestCtrl.suggestList;
          }

          return buildSuggestListView(suggests);
        },
      ),
    );
  }
}
