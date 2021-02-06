# 分享自制Flutter版的ReadHub的经验和历程
## **关于ReadHub的描述**
关注冯大的公众号很久了，经常受到他的"小道消息"的熏陶，也经常看看他的ReadHub。 

现在要看点新闻，也真是不容易，标题党、硬广、软广、重复新闻充斥其中，特别浪费时间。

ReadHub对科技新闻、热点资讯进行了一定程度的聚合和筛选，标题清楚直白，还附带了一段简短的内容介绍。感不感兴趣，简单看下标题就基本够了，感兴趣的点进去可以查看详细内容和来龙去脉，只想了解一下的， 点击看看简短介绍即可。

## **为什么制作这个App**
对于我们这种只想利用一下碎片化时间的人来说，ReadHub真的是不错。不过官方只有网页版和小程序。上班间隙看看网页版还是不错的，小程序就有点尴尬了，微信要经常切换聊天，想安静的看会都不大方便。网上也有不少牛人制作了App, 干脆我也搞一个吧。

有图有真相, 没图的话大家就没兴趣读下去, 是吧! 那就先把操作动画放出来吧.

![操作动画](readhub_ani02_yy.gif)

## **简单介绍一下API**
感谢官方开放了API，虽然不是正式的，但对于第三方却保持着一份开放的心态，感谢！ 

简单介绍如下：
- **热门话题**

    https://api.readhub.cn/topic?pageSize=xx 

    拉取最新的xx条topic

    https://api.readhub.cn/topic?pageSize=xx&lastCursor=xxxxx 

    拉取order为xxxxx的topic之前(更早)的xx条topic
    
    > - pageSize: 拉取的topic数量
    > - lastCursor: 上一次访问的最后一条资讯的order

- **话题详情**

    https://api.readhub.cn/topic/xxxxxx
    
    拉取id为xxxxxx的话题详情

- **即时信息**

    https://api.readhub.cn/topic/instantview?topicId=xxxxxx

    拉取id为xxxxxx的即时信息

- **科技动态**

    https://api.readhub.cn/news?pageSize=xx&lastCursor=xxxxx

    > - lastCursor：上一次访问的最后一条资讯的 PublishDate 对应的**毫秒时间戳**, 为空时拉取最新的news
    > - pageSize：一次请求拉取的话题数目

- **开发者资讯(参数描述同上)**

    https://api.readhub.cn/technews?pageSize=xx&lastCursor=xxxxx

- **区块链资讯(参数描述同上)**

    https://api.readhub.cn/blockchain?pageSize=xx&lastCursor=xxxxx

- **搜索**

    https://search.readhub.cn/api/entity/news?page=1&size=20&query=xxxxx&type=hot

    > - page: 页数, 拉取到的数据中可以看到totalPages
    > - size：一次请求拉取的话题数目
    > - query: 关键字, 就是搜索的内容
    > - type: hot,热门话题, 还有一个all, 我舍弃掉了

- **搜索建议**

    https://search.readhub.cn/api/entity/suggest?q=h

    > - q: 输入搜索框时的关键字

- 还有一个newCount, 每隔一段时间报告更新了xx条topic, 可以用来给某个Tab标签加个红标记, 我想了想, 可能会给使用者带来焦虑感, 所以还是不用它吧.

## **制作Model**

有了API, 首先我们得观察一下官方API返回的Json数据, 建议在浏览器里装一个json解析器的扩展, 对分析Json结构非常有帮助.

![Json示例](https://neoapp.oss-cn-shanghai.aliyuncs.com/json_01.png)

然后是制作对应数据模型Model, 网上比较热门的json_to_dart有不少, 我用的是 https://javiercbk.github.io/json_to_dart/ , 根据API取得完整的JSON数据, 粘贴进去, 填写希望生成的Model名称, 一键即可生成.  

为了方便后面阅读, 我一般在生成后稍微改几个类的名称, 例如将Data改成TopicData.

总共生成的Model如下:

> - TopicModel.dart
> - TopicDetailsModel.dart
> - InstantViewModel.dart
> - NewsModel.dart
> - SearchModel.dart
> - SuggestModel.dart

## **简单描述一下App框架和逻辑**


既然官方都这么精简了, 我的App也不能做的太复杂,够用即可.

### **第三方插件**

本程序借用了一些第三方插件, 如下:

```dart
  # http
  dio: ^3.0.10
  # 状态管理
  get: ^3.24.0
  # 下拉刷新
  pull_to_refresh: ^1.6.3
  # webview
  webview_flutter: ^1.0.7
  # 时间格式
  date_format: ^1.0.9
  # html解析
  flutter_html: ^1.1.1
  #二维码-生成
  qr_flutter: ^3.1.0
  #文件路径
  path_provider: ^1.6.27
  #动态权限申请
  permission_handler: ^5.0.1
  # 分享
  share: ^0.6.5+4
  # 闪光效果
  shimmer: ^1.1.2
```


有如下几个页面:

### **1. 主页**

采用普通的TabBar + TabBarView的形式组织主页, 列举了"热门话题", "科技动态", "技术资讯"和"区块链"资讯共4个Tab.

其中热门话题列表点开可以进入详情页, 其它3个Tab的列表项点开后进入Webview详细介绍, 显示的是第三方的url的内容.

![主页](https://neoapp.oss-cn-shanghai.aliyuncs.com/readhub_01.png)



### **2. 详情页**

主要内容(content)部分,默认显示InstantView的内容. 毕竟在TopicScreen页面点击一下就能看到summary, 如果点击进来看详情, 还看到的是summary确实没啥意思. 但`hasInstantView == false`时, 显示TopicDetailsModel的summary.  InstantView中包含的都是HTML格式的文本, 我调用了flutter_html插件来做简单显示.

![HTML](https://neoapp.oss-cn-shanghai.aliyuncs.com/readhub_06.png)

官方根据热门程度, 列出了一些公司(company),个人(person)或机构(organization)等, 如:华为、 罗永浩、 工信部等, 用于付费订阅. 我也将其作为关键字列在content下, 点击即可查看其关联的话题或新闻. 

同时在下方列出了媒体报道的链接, 和关联事件或事件追踪.

![详情页](https://neoapp.oss-cn-shanghai.aliyuncs.com/readhub_02.png)



### **3. Webview页**

采用Webview插件显示第三方url的内容.

![Webview页](https://neoapp.oss-cn-shanghai.aliyuncs.com/readhub_03.png)

### **4. 搜索**
搜索页面提供搜索建议, 所有搜索建议都来源于官方API, 

![搜索](https://neoapp.oss-cn-shanghai.aliyuncs.com/readhub_04.png)

## **GetX的简单介绍**

这个APP的状态管理用的是GetX. 这是最近比较火的一个插件, 既有状态管理功能, 又能做路由管理, 还能做国际化语言管理. 可以抛开context使用, 简单好用. 我从官方拉过来的数据都通过它来管理. 

 - TopicController: 热门话题的数据管理

    > 配套的页面是TopicScreen,  使用前用Get.put加载到内存里, 然后用GetBuilder将数据绑定到需要显示的Widget上
    > 
    加载数据
    ```dart
    topicController = Get.find<TopicController>();
    ```

    显示数据

    ```dart
    GetBuilder<TopicController>(builder: (_) {
            // PullToFresh + ListView 下拉刷新插件+ListView列表
        }
    )
    ```

- NewsController: 三种新闻的数据管理, 通过newsType来做识别, 

    > 注意三种新闻的页面,共用了一个XNewsScreen基类, 为了避免被互相替换掉, 还需要用tag参数做区分
    > 
    加载数据
    ```dart
    newsController = Get.put(
      NewsController(newsType: widget.newsType),
      permanent: true,
      tag: widget.tag,
    );
    ```
    
    显示数据, 使用时也要使用同一个tag确保不要混淆不同的controller

    ```dart
    GetBuilder<NewsController>(
        tag: widget.tag,
        builder: (_) {
            // PullToFresh + ListView 下拉刷新插件+ListView列表
        }
    )
    ```

- TopicDetailsController 详情页的数据管理

- InstantViewController 即时信息内容的数据管理, 内容并入了详情页中

- SearchController 搜索页面的数据管理

- SuggestController 搜索建议栏的数据管理

## **一些特性的实现思路**
### **跟随系统主题**

- 默认跟随系统, 会自动根据系统明暗调整主题

- 在明亮系统主题下, 可以手工切换亮色和深色模式

- 深色系统主题下, 只能跟随深色模式

![深色主题](https://neoapp.oss-cn-shanghai.aliyuncs.com/readhub_05.png) 

分四步来实现这个功能.



1- 创建MyTheme主题类

```dart
abstract class MyTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Color(0xFF2B648C),
    primaryColorLight: Colors.black,
    primaryColorDark: Color(0xFF3C4042),
    accentColor: Colors.orange,
    backgroundColor: Color(0xFFF0F0F0),
    scaffoldBackgroundColor: Colors.white,
    secondaryHeaderColor: Colors.grey,
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Color(0xFF101010),
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.white70,
    accentColor: Color(0xFF16B888),
    backgroundColor: Color(0xFF101010),
    scaffoldBackgroundColor: Color(0xFF3C4042),
    secondaryHeaderColor: Colors.grey,
  );
}
```
2- 入口程序加载主题

常规的MaterialApp被GetMaterialApp替换掉了

```dart
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
```

3- 手动切换

   其实到这一步, 系统切换到深色模式, app也会自动跟随切换过去的. 但若在亮色模式下已经手动切换到了深色模式, 当系统再切换成亮色模式时, app不会跟随变更为亮色模式, 还是需要手动切换, 所以还要看第4步

```dart
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
```

4- 跟随系统改变

   监听App生命周期变化, 同步做变更.

```dart
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
```

功能是实现了, 但其实有一个***Bug***, 你看出来了吗? 

### **分享功能**

针对每一个主题都提供了分享功能, 可分享至微信等.

![分享](https://neoapp.oss-cn-shanghai.aliyuncs.com/readhub_07.png)

分享插件用的是share, 按官方的说法, 其实在Android下调用的是 ACTION_SEND intent, IOS下调用的是UIActivityViewController, 支持文本和文件. 

分享功能涉及到截屏, 访问存储权限, 保存图片和分享图片功能, 部分借鉴了[AriesHoo](https://www.jianshu.com/p/5e1db7423dac)同学的代码, 在此感谢.

**1- 需要预先为APP申请权限**, 在android和Ios目录进行一点设置.

在android/app/src/main/AndroidManifest.xml中添加

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

在ios/Runner/Info.plist中添加

```xml
<!-- Permission options for the `photos` group -->
<key>NSPhotoLibraryUsageDescription</key>
<string>photos</string>
```

主要代码如下:

**2- 把需要分享的内容用RepaintBoundary包裹**

```dart
RepaintBoundary(
  key: globalKey,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(2),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          Text(widget.detailsModel.title, style: titleStyle),
          SizedBox(height: 10),
          Container(
            // 代码过多, 省略
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Text('Powered by Truly', style: deAccentStyle),
          ),
        ],
      ),
    ),
  ),
)
```

**3- 截图**

```dart
/// 截图
Future<Uint8List> _capturePng() async {
  try {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: Get.pixelRatio);
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  } catch (e) {
    print(e);
  }
  return null;
}
```
**4- 检查权限, 分享**

检查权限, 首次启动分享功能会提示授权, 之后如果没有权限, 会弹出一个对话框让你去授权,

获取截图, 存储文件, 然后分享

```dart
save2Share() async {
  // 第一次: 检查一下权限是否授权过, 如果没授权, 给个弹窗去授权, 如果不授权, 则退出
  if (!await _checkStoragePermission()) {
    print('分享功能需使用访问您的${Platform.isIOS ? '照片' : '文件读写'}的权限');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ReadHub提示'),
        content: Text('分享功能需使用访问您的${Platform.isIOS ? '照片' : '文件读写'}的权限'),
        actions: [
          OutlinedButton(
            onPressed: () {
              Get.back();
              print('分享无法继续,退出');
              return;
            },
            child: Text('暂不授权',
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('去授权'),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
  // 如果openAppSettings()中做了操作, 可以再检查一下是否取得了权限, 没取得还是得退出
  if (!await _checkStoragePermission()) return;
  //
  print('您已获得了访问您的${Platform.isIOS ? '照片' : '文件读写'}的权限');
  String filename = await _getFileName();
  File saveFile = File(filename);
  //
  bool exist = saveFile.existsSync() && saveFile.lengthSync() > 0;
  if (!exist) {
    if (!saveFile.existsSync()) {
      print('文件$saveFile不存在, 需要创建它');
      await saveFile.create();
    }
    File file = await saveFile.writeAsBytes(await _capturePng());
    exist = file.existsSync();
  }

  if (exist) {
    // share
    Share.shareFiles([filename], text: 'ReadHub分享');
    Get.back();
  }
}

```

## 官方API的几个坑

官方的API大体上还是非常友好的, 但有几个坑让我debug了好几天.

### **官方会无规律性的删除某条或某几条热门话题**

- 因为我在内存中保存了第一条Topic的order, 存入firstOrder, 用于与新拉取的Topic做对比, 正常情况下, 若新拉取的Topics包含了firstOrder, 说明更新了部分, 若不包含它, 则需要补充一条一条拉取Topic, 逐条做对比, 直到找到原来的第一条Topic为止, 这样就能确定到底需要显示多少条Topic. 但若官方删除了第一条Topic, 则新拉取的Topics永远找不到可以对照的order, 然后下拉刷新的圈圈就转啊转啊, 更坑爹的事, 有时候删除的不止第一条, 会删除好几条. 因此在下拉刷新前必须做一次更新firstOrder的检测.

- 检查某条topic是否被删除, 只能用死办法, 根据topicId访问下就知道了, 但这里也有坑, 正常情况下确定`res.data == null` 即可判断出来, 但有时得到的数据是`res.data = {}`,  要不然你以为下面代码的`res.data.toString().length <= 4`是怎么来的啊, 哭...

```dart
  /// 检查第一条topic是否被删除了, 若被删除, 则下拉刷新的参照依据就没了, 需要替换
  Future<bool> _checkFirstAlive() async {
    try {
      if (_dio == null) _initDio();
      var res = await _dio.get('/topic/${_normalTopics.first.id}');

      if (res.statusCode == 200) {
        int count = 0;
        while (res.data.toString().length <= 4) {
          print('最顶的一条topic被删除了, :( ,挑选下面一条topic的order作为下拉刷新的依据');
          _normalTopics.removeAt(0);
          _firstOrder = _normalTopics.first.order.toString();
          topics.removeAt(_topTopics.length);
          count += 1;
          res = await _dio.get('/topic/${_normalTopics.first.id}');
          if (res.statusCode != 200) return false;
        }

        update();
        print('第一条topic检查完毕! 总共删除了$count条Topic, 可以继续');
        // showSnack('检查', '第一条topic检查完毕! 总共删除了$count条Topic, 可以继续');
        return true;
      } else {
        print('检测First: dio error status = ${res.statusCode}');
        showSnack('网络错误', '下拉检查时遇到服务端故障, 故障代号: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('检测First: ${e.toString()}');
      showSnack('错误', '可能网络不通, 或者服务器有问题, 无法更新.');
      return false;
    }
  }
```

### **官方热门话题频道竟然有置顶功能**

我盯着官方网页看了好多天, 微信十周年那天, 一条张小龙的Topic置顶了几乎一整天, 既然这个Topic是第一条, 更新时我的参照firstOrder硬是没发生过变化, 当然内容一直不变啦.

查网站API也没发现什么有价值的线索, 不过无意中比对order, 发现官方对于置顶的方法是在原来6位数的order前面加个1, 变成7位数, 好尴尬...

```dart
// 置顶的topic加入到_topTopics列表中
tmpTopics.forEach((topicData) {
  if (topicData.order > 1000000) {
    _topTopics.add(topicData);
  }
});
// 非置顶的topic加入到_normalTopics中
_normalTopics.addAll(tmpTopics.sublist(_topTopics.length));
```

更尴尬的是, 那天白天有事忙活, 只能抽空思考了一下, 等我自认为找到原因, 费劲巴拉的写好判断代码, 官方把置顶取消了, 他取消了, 测试进行不下去了...

![吐血](https://th.bing.com/th/id/R433f415ae6f971dd4269090938a6d05d?rik=E4YE7KKhhyobig&riu=http%3a%2f%2fup.54fcnr.com%2fpic_360%2fcc%2f4f%2f9d%2fcc4f9deb8c11dab386fa74c484534524.gif&ehk=6gqtU1i7do33ZN5uurV4qTzgZhyKYzehytxDxK604DY%3d&risl=&pid=ImgRaw)

## **结束**

好吧, App也写完了, 我也用了好几天, 总体上还是比较稳定的, 我跳出上面几个坑以后再没遇到过转圈圈的事了. 但还有几个TODO项, 看以后有心情再决定是不是优化或改造一下吧.
- 偶尔会点击到无内容的topic, 应该是被官方删除了, 需要做404改造
- 要不要增加Topic的收藏功能呢?
- 要不要把那些Entity(Company, Person, Organization)等做成单独成页呢?
- 加个评论...?

## **欢迎下载和提Issue**

真结束了, 欢迎评论, 下载APP, 并提Issue给我.

## **ReadHub App(只限Android)**
![App](https://neoapp.oss-cn-shanghai.aliyuncs.com/readhub_app.png)

## **App代码开源**
[github](https://github.com/wxpcl123/readhub)

![github](https://neoapp.oss-cn-shanghai.aliyuncs.com/readhub_code.png)

## **2021-02-06更新**

难得等到官方又出现置顶了, 然后我发现置顶算法有问题, 所以更新了一下,  试用下来好像OK了.


```dart
tmpTopics.forEach((topicData) {
  if (topicData.order > 1000000) {
    // 有置顶内容也要看下是否已包含了
    bool included = false;
    _topTopics.forEach((topTopic) {
      if (topTopic.id == topicData.id) {
        included = true;
      } 
    });
    if (!included) {
      _topTopics.insert(0, topicData);
      topics.insert(0, topicData);
    }
  } else {
    orderList.add(topicData.order.toString());
  }
});
```

效果如图:

![置顶](toplizer01.png)

