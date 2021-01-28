/// 1- 未输入搜索关键的词, 会报错, 不适用该model, 在其对应的[controller]中单独处理
/// 例: https://search.readhub.cn/api/entity/suggest?q=
/// 2- 输入搜索的关键词, 但没有得到匹配的反馈, 也不适用该model, 在其对应的[controller]中单独处理
/// 例: https://search.readhub.cn/api/entity/suggest?q=gda
/// 返回[
/// {
///   "data": {
///     "items": [
///     ]
///   }
/// }
/// 3- 正常输入, 得到正确反馈
/// 例: https://search.readhub.cn/api/entity/suggest?q=%E9%9B%B7

class SuggestModel {
  Result result;

  SuggestModel({this.result});

  SuggestModel.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  SuggestData suggestData;

  Result({this.suggestData});

  Result.fromJson(Map<String, dynamic> json) {
    suggestData =
        json['data'] != null ? new SuggestData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.suggestData != null) {
      data['data'] = this.suggestData.toJson();
    }
    return data;
  }
}

class SuggestData {
  List<SuggestItem> items;

  SuggestData({this.items});

  SuggestData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        /// 注意, 某些情况下, api返回的数据, 不都是完全[SuggestItem]格式的条目,
        /// 也有可能是一条[String]类型的条目, 需要剔除
        if (v.runtimeType != String) items.add(new SuggestItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SuggestItem {
  String text;
  String entityType;
  String entityName;
  String entityId;
  String type;

  SuggestItem(
      {this.text, this.entityType, this.entityName, this.entityId, this.type});

  SuggestItem.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    entityType = json['entityType'];
    entityName = json['entityName'];
    entityId = json['entityId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['entityType'] = this.entityType;
    data['entityName'] = this.entityName;
    data['entityId'] = this.entityId;
    data['type'] = this.type;
    return data;
  }
}
