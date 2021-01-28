import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../common/my_theme.dart';

class Menu extends StatelessWidget {
  //
  _switchTheme(BuildContext context) {
    if (!Get.isPlatformDarkMode) {
      Get.changeTheme(Get.isDarkMode ? MyTheme.lightTheme : MyTheme.darkTheme);
    } else {
      Get.snackbar(
        '提示',
        '当前处于系统深色模式, 无法更改主题',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(5),
        borderRadius: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      );
    }
  }

  _qrIntro(BuildContext context, String data, String title) {
    return Column(
      children: [
        QrImage(
          data: data,
          size: 100,
          padding: EdgeInsets.only(bottom: 10),
          foregroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        Text(title),
      ],
    );
  }

  _showAuthor(BuildContext context) {
    var titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    var summaryStyle = TextStyle(fontSize: 14, letterSpacing: 1.6, height: 1.6);
    String desc1 = '本程序作者Truly, 是一个业余编码爱好者.';
    String desc2 = '我们每个人都是业余爱好者.我们都活得不够久, 没办法脱离这个境地.';
    String desc3 = '---英国喜剧演员 查理·卓别林';

    showDialog(
      context: context,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('关于作者', style: titleStyle),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          width: 0.5,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(desc1, style: summaryStyle),
                          SizedBox(height: 10),
                          Text(desc2, style: summaryStyle),
                          SizedBox(height: 10),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Text(desc3, style: summaryStyle)),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _qrIntro(context, 'https://neoapp.top', '网站'),
                              _qrIntro(context, 'https://github.com/wxpcl123',
                                  'GitHub'),
                              _qrIntro(
                                  context,
                                  'https://qm.qq.com/cgi-bin/qm/qr?k=O22w1SnmzVJBKYLfLOh2ZieHkvxm9-sc&noverify=0',
                                  'QQ'),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                backgroundColor: Theme.of(context).accentColor,
                onPressed: () => Get.back(),
                child: Icon(Icons.clear),
              ),
            ],
          ),
        );
      },
    );
  }

  _showAbout(BuildContext context) {
    var titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    var summaryStyle = TextStyle(fontSize: 14, letterSpacing: 1.6, height: 1.6);
    String desc =
        """
本软件是一个极简、轻巧的科技新闻实时分享客户端. 数据来源于无码科技, 版权归无码科技所有. 本人出于学习的目的而制作了该软件.

申明:
1. 本软件借鉴了AriesHoo同学的部分代码, 在此进行感谢.
2. 本软件所有数据来源于Readhub官方, 除分享时会在临时文件夹保留截图外, 未在本机和第三方做任何存储和记录.
""";
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('软件说明', style: titleStyle),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          width: 0.5,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      child: Text(desc, style: summaryStyle),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                backgroundColor: Theme.of(context).accentColor,
                onPressed: () => Get.back(),
                child: Icon(Icons.clear),
              ),
            ],
          ),
        );
      },
    );
  }

  _onMenuItemSelected(BuildContext context, String value) {
    switch (value) {
      case 'theme':
        _switchTheme(context);
        break;
      case 'author':
        _showAuthor(context);
        break;
      case 'about':
        _showAbout(context);
        break;
      default:
    }
  }

  Widget menuItem(
      BuildContext context, IconData icon, String value, String title) {
    var color = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Theme.of(context).primaryColor;
    return PopupMenuItem(
      value: value,
      child: ListTile(
        leading: Text(title),
        title: SizedBox(width: 100),
        trailing: Icon(icon, color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz),
      elevation: 1,
      color: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).backgroundColor
          : Theme.of(context).scaffoldBackgroundColor,
      onSelected: (value) {
        _onMenuItemSelected(context, value);
      },
      itemBuilder: (context) {
        return [
          menuItem(context, Icons.color_lens_outlined, 'theme', '切换主题'),
          menuItem(context, Icons.person_outline, 'author', '作者是谁'),
          menuItem(context, Icons.info_outline, 'about', '软件说明'),
        ];
      },
    );
  }
}
