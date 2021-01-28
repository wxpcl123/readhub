import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

import '../models/topic_details_model.dart';
import 'app_title.dart';

class ShareTopic extends StatefulWidget {
  final TopicDetailsModel detailsModel;

  ShareTopic({Key key, this.detailsModel}) : super(key: key);

  @override
  _ShareTopicState createState() => _ShareTopicState();
}

class _ShareTopicState extends State<ShareTopic> {
  GlobalKey globalKey = GlobalKey();

  // 第一次运行时会弹出一个权限确认框,
  Future<bool> _checkStoragePermission() async {
    Permission permission =
        Platform.isAndroid ? Permission.storage : Permission.photos;
    PermissionStatus status = await permission.status;
    if (status != PermissionStatus.granted) {
      print('在这里申请${Platform.isIOS ? '照片' : '文件读写'}的权限');
      status = await permission.request();
      print('status == $status');
      return status == PermissionStatus.granted;
    } else {
      return true;
    }
  }

  /// 获取地址和文件名
  _getFileName() async {
    var tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String fileName = '$tempPath/${widget.detailsModel.id}.png';
    return fileName;
  }

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

  @override
  Widget build(BuildContext context) {
    // 分享视图
    Widget contentView() {
      var titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
      var summaryStyle =
          TextStyle(fontSize: 14, letterSpacing: 1.6, height: 1.6);
      var deAccentStyle = TextStyle(
          fontSize: 12, color: Theme.of(context).secondaryHeaderColor);
      // RepaintBoundary包裹的组件都可以被截图
      return RepaintBoundary(
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      width: 0.5,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.detailsModel.summary,
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: summaryStyle,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppTitle(),
                            QrImage(
                              data:
                                  'https://readhub.cn/topic/${widget.detailsModel.id}',
                              size: 100,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              foregroundColor: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            contentView(),
            SizedBox(height: 20),
            FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(Icons.share),
              onPressed: () {
                save2Share();
              },
            )
          ],
        ),
      ),
    );
  }
}
