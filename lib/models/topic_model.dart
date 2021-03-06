// https://api.readhub.cn/topic?pageSize=10&lastCursor=xxxxxx

/// 热门话题topic的模型
class TopicModel {
  List<TopicData> topicDatas;
  int pageSize;
  int totalItems;
  int totalPages;

  TopicModel(
      {this.topicDatas, this.pageSize, this.totalItems, this.totalPages});

  TopicModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      topicDatas = []; //new List<TopicData>();
      json['data'].forEach((v) {
        topicDatas.add(new TopicData.fromJson(v));
      });
    }
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> topicData = new Map<String, dynamic>();
    if (this.topicDatas != null) {
      topicData['data'] = this.topicDatas.map((v) => v.toJson()).toList();
    }
    topicData['pageSize'] = this.pageSize;
    topicData['totalItems'] = this.totalItems;
    topicData['totalPages'] = this.totalPages;
    return topicData;
  }
}

class TopicData {
  String id;
  List<NewsArray> newsArray;
  String createdAt;
  List<EventData> eventData;
  String publishDate;
  String summary;
  String title;
  String updatedAt;
  String timeline;
  int order;
  bool hasInstantView;
  Extra extra;

  TopicData(
      {this.id,
      this.newsArray,
      this.createdAt,
      this.eventData,
      this.publishDate,
      this.summary,
      this.title,
      this.updatedAt,
      this.timeline,
      this.order,
      this.hasInstantView,
      this.extra});

  TopicData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['newsArray'] != null) {
      newsArray = []; //new List<NewsArray>();
      json['newsArray'].forEach((v) {
        newsArray.add(new NewsArray.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    if (json['eventData'] != null) {
      eventData = []; //new List<EventData>();
      json['eventData'].forEach((v) {
        eventData.add(new EventData.fromJson(v));
      });
    }
    publishDate = json['publishDate'];
    summary = json['summary'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    timeline = json['timeline'];
    order = json['order'];
    hasInstantView = json['hasInstantView'];
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.newsArray != null) {
      data['newsArray'] = this.newsArray.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    if (this.eventData != null) {
      data['eventData'] = this.eventData.map((v) => v.toJson()).toList();
    }
    data['publishDate'] = this.publishDate;
    data['summary'] = this.summary;
    data['title'] = this.title;
    data['updatedAt'] = this.updatedAt;
    data['timeline'] = this.timeline;
    data['order'] = this.order;
    data['hasInstantView'] = this.hasInstantView;
    if (this.extra != null) {
      data['extra'] = this.extra.toJson();
    }
    return data;
  }
}

class NewsArray {
  int id;
  String url;
  String title;
  String siteName;
  String mobileUrl;
  String autherName;
  int duplicateId;
  String publishDate;
  String language;
  bool hasInstantView;
  int statementType;

  NewsArray(
      {this.id,
      this.url,
      this.title,
      this.siteName,
      this.mobileUrl,
      this.autherName,
      this.duplicateId,
      this.publishDate,
      this.language,
      this.hasInstantView,
      this.statementType});

  NewsArray.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    title = json['title'];
    siteName = json['siteName'];
    mobileUrl = json['mobileUrl'];
    autherName = json['autherName'];
    duplicateId = json['duplicateId'];
    publishDate = json['publishDate'];
    language = json['language'];
    hasInstantView = json['hasInstantView'];
    statementType = json['statementType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['title'] = this.title;
    data['siteName'] = this.siteName;
    data['mobileUrl'] = this.mobileUrl;
    data['autherName'] = this.autherName;
    data['duplicateId'] = this.duplicateId;
    data['publishDate'] = this.publishDate;
    data['language'] = this.language;
    data['hasInstantView'] = this.hasInstantView;
    data['statementType'] = this.statementType;
    return data;
  }
}

class EventData {
  int id;
  String topicId;
  int eventType;
  String entityId;
  String entityType;
  String entityName;
  int state;
  String createdAt;
  String updatedAt;

  EventData(
      {this.id,
      this.topicId,
      this.eventType,
      this.entityId,
      this.entityType,
      this.entityName,
      this.state,
      this.createdAt,
      this.updatedAt});

  EventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topicId = json['topicId'];
    eventType = json['eventType'];
    entityId = json['entityId'];
    entityType = json['entityType'];
    entityName = json['entityName'];
    state = json['state'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topicId'] = this.topicId;
    data['eventType'] = this.eventType;
    data['entityId'] = this.entityId;
    data['entityType'] = this.entityType;
    data['entityName'] = this.entityName;
    data['state'] = this.state;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Extra {
  bool instantView;

  Extra({this.instantView});

  Extra.fromJson(Map<String, dynamic> json) {
    instantView = json['instantView'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['instantView'] = this.instantView;
    return data;
  }
}
