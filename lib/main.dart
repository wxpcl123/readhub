import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'common/my_theme.dart';
import 'home_page.dart';

void main() async {
  /// 设置全屏
  WidgetsFlutterBinding.ensureInitialized();

  /// 设置手机方向
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// 设置android的状态栏为透明色
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: false,
      debugShowCheckedModeBanner: false,
      title: 'ReadHub',
      // 亮色和暗色主题, App默认跟随系统设置
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      // 页面间切换的动画
      defaultTransition: Transition.cupertino,
      //
      home: HomePage(),
    );
  }
}
