// https://api.readhub.cn/topic/topicId

class TopicDetailsModel {
  String id;
  List<EntityTopic> entityTopics;
  List<News> newsArray;
  String createdAt;
  String publishDate;
  String summary;
  String title;
  String updatedAt;
  Timeline timeline;
  int order;
  bool hasInstantView;
  String timelineId;

  TopicDetailsModel(
      {this.id,
      this.entityTopics,
      this.newsArray,
      this.createdAt,
      this.publishDate,
      this.summary,
      this.title,
      this.updatedAt,
      this.timeline,
      this.order,
      this.hasInstantView,
      this.timelineId});

  TopicDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['entityTopics'] != null) {
      entityTopics = [];
      json['entityTopics'].forEach((v) {
        entityTopics.add(new EntityTopic.fromJson(v));
      });
    }
    if (json['newsArray'] != null) {
      newsArray = [];
      json['newsArray'].forEach((v) {
        newsArray.add(new News.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    publishDate = json['publishDate'];
    summary = json['summary'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    timeline = json['timeline'] != null
        ? new Timeline.fromJson(json['timeline'])
        : null;
    order = json['order'];
    hasInstantView = json['hasInstantView'];
    timelineId = json['timelineId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.entityTopics != null) {
      data['entityTopics'] = this.entityTopics.map((v) => v.toJson()).toList();
    }
    if (this.newsArray != null) {
      data['newsArray'] = this.newsArray.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;

    data['publishDate'] = this.publishDate;
    data['summary'] = this.summary;
    data['title'] = this.title;
    data['updatedAt'] = this.updatedAt;
    if (this.timeline != null) {
      data['timeline'] = this.timeline.toJson();
    }
    data['order'] = this.order;
    data['hasInstantView'] = this.hasInstantView;
    data['timelineId'] = this.timelineId;
    return data;
  }
}

class EntityTopic {
  String nerName;
  String entityId;
  String entityName;
  String entityType;
  Finance finance;

  EntityTopic(
      {this.nerName,
      this.entityId,
      this.entityName,
      this.entityType,
      this.finance});

  EntityTopic.fromJson(Map<String, dynamic> json) {
    nerName = json['nerName'];
    entityId = json['entityId'];
    entityName = json['entityName'];
    entityType = json['entityType'];
    finance =
        json['finance'] != null ? new Finance.fromJson(json['finance']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nerName'] = this.nerName;
    data['entityId'] = this.entityId;
    data['entityName'] = this.entityName;
    data['entityType'] = this.entityType;
    if (this.finance != null) {
      data['finance'] = this.finance.toJson();
    }
    return data;
  }
}

class Finance {
  String code;
  String name;

  Finance({this.code, this.name});

  Finance.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class News {
  String id;
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

  News(
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

  News.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> news = new Map<String, dynamic>();
    news['id'] = this.id;
    news['url'] = this.url;
    news['title'] = this.title;
    news['siteName'] = this.siteName;
    news['mobileUrl'] = this.mobileUrl;
    news['autherName'] = this.autherName;
    news['duplicateId'] = this.duplicateId;
    news['publishDate'] = this.publishDate;
    news['language'] = this.language;
    news['hasInstantView'] = this.hasInstantView;
    news['statementType'] = this.statementType;
    return news;
  }
}

class Timeline {
  List<Topic> topics;
  List<CommonEntity> commonEntities;
  String id;

  Timeline({this.topics, this.commonEntities, this.id});

  Timeline.fromJson(Map<String, dynamic> json) {
    if (json['topics'] != null) {
      topics = [];
      json['topics'].forEach((v) {
        topics.add(new Topic.fromJson(v));
      });
    }
    if (json['commonEntities'] != null) {
      commonEntities = [];
      json['commonEntities'].forEach((v) {
        commonEntities.add(new CommonEntity.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> timeline = new Map<String, dynamic>();
    if (this.topics != null) {
      timeline['topics'] = this.topics.map((v) => v.toJson()).toList();
    }
    timeline['id'] = this.id;
    return timeline;
  }
}

class Topic {
  String id;
  String title;
  String createdAt;

  Topic({this.id, this.title, this.createdAt});

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> topic = new Map<String, dynamic>();
    topic['id'] = this.id;
    topic['title'] = this.title;
    topic['createdAt'] = this.createdAt;
    return topic;
  }
}

class CommonEntity {
  String id;
  CommonEntity({this.id});

  CommonEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> commonEntity = Map<String, dynamic>();
    commonEntity['id'] = this.id;
    return commonEntity;
  }
}
