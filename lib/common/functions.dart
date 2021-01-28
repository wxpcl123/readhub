/// Common Functions
/// 通用函数汇总

import 'package:date_format/date_format.dart';
import 'package:get/get.dart';

/// 根据给出的时间, 计算与当前时间的距离, 返回人性化的描述
///
String timeAhead(DateTime dateTime) {
  Duration duration = DateTime.now().difference(dateTime);
  if (duration < Duration.zero) {
    return '未来';
  }
  return duration.inDays / 365 >= 1
      ? '${duration.inDays ~/ 365}年前' // 除后取整
      : duration.inDays / 30 >= 1
          ? '${(duration.inDays ~/ 30)}月前' // 除后取整
          : duration.inDays >= 1
              ? '${duration.inDays}天前'
              : duration.inHours >= 1
                  ? '${duration.inHours}小时前'
                  : duration.inMinutes >= 3
                      ? '${duration.inMinutes}分钟前'
                      : '刚刚';
}

/// - 当年返回x年x月
/// - 否则返回xxxx年x月x日
///
String timeAsDay(DateTime dateTime) {
  if (dateTime.year == DateTime.now().year)
    return formatDate(dateTime, [mm, '月', dd, '日']);
  return formatDate(dateTime, [yyyy, '年', mm, '月', dd, '日']);
}

/// 弹出一个SnackBar
showSnack(String title, String message, {Duration duration}) {
  Get.showSnackbar(
    GetBar(
      title: title,
      message: message,
      duration: duration ?? Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    ),
  );
}
