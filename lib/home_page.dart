import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common/my_theme.dart';
import 'screens/search_screen.dart';
import 'screens/topic_screen.dart';
import 'screens/news_screen.dart';
import 'screens/technews_screen.dart';
import 'screens/blockchain_screen.dart';
import 'widgets/app_title.dart';
import 'widgets/menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver {
  //
  TabController tabController;

  List<String> tabStrings = ['热门话题', '科技动态', '技术资讯', '区块链'];

  List<Widget> screens = [
    TopicScreen(),
    NewsScreen(),
    TechnewsScreen(),
    BlockchainScreen(),
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (Get.isPlatformDarkMode) {
        Get.changeTheme(MyTheme.darkTheme);
      } else {
        Get.changeTheme(MyTheme.lightTheme);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabStrings.length, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  onTabTap(int index) {
    print('index = $index');
  }

  Widget tabBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: TabBar(
          controller: tabController,
          onTap: onTabTap,
          labelColor: Theme.of(context).primaryColorLight,
          labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          unselectedLabelColor: Theme.of(context).primaryColorDark,
          unselectedLabelStyle:
              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          labelPadding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Theme.of(context).accentColor,
          tabs: List.generate(
            tabStrings.length,
            (index) => Tab(text: tabStrings[index]),
          ),
        ),
      ),
    );
  }

  List<Widget> actions() {
    return [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () => Get.to(SearchScreen()),
      ),
      Menu(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: false,
        title: AppTitle(),
        actions: actions(),
        bottom: tabBar(),
      ),
      body: TabBarView(
        controller: tabController,
        children: screens,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
