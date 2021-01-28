// https://search.readhub.cn/api/entity/news?page=1&size=20&query=%E9%AB%98%E9%80%9A&type=hot

class SearchModel {
  SearchData searchData;

  SearchModel({this.searchData});

  SearchModel.fromJson(Map<String, dynamic> json) {
    searchData =
        json['data'] != null ? SearchData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> searchData = new Map<String, dynamic>();
    if (this.searchData != null) {
      searchData['data'] = this.searchData.toJson();
    }
    return searchData;
  }
}

class SearchData {
  int totalItems;
  int startIndex;
  int pageIndex;
  int itemsPerPage;
  int currentItemCount;
  int totalPages;
  List<Item> items;
  Self self;

  SearchData(
      {this.totalItems,
      this.startIndex,
      this.pageIndex,
      this.itemsPerPage,
      this.currentItemCount,
      this.totalPages,
      this.items,
      this.self});

  SearchData.fromJson(Map<String, dynamic> json) {
    totalItems = json['totalItems'];
    startIndex = json['startIndex'];
    pageIndex = json['pageIndex'];
    itemsPerPage = json['itemsPerPage'];
    currentItemCount = json['currentItemCount'];
    totalPages = json['totalPages'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(new Item.fromJson(v));
      });
    }
    self = json['self'] != null ? new Self.fromJson(json['self']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> searchData = new Map<String, dynamic>();
    searchData['totalItems'] = this.totalItems;
    searchData['startIndex'] = this.startIndex;
    searchData['pageIndex'] = this.pageIndex;
    searchData['itemsPerPage'] = this.itemsPerPage;
    searchData['currentItemCount'] = this.currentItemCount;
    searchData['totalPages'] = this.totalPages;
    if (this.items != null) {
      searchData['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.self != null) {
      searchData['self'] = this.self.toJson();
    }
    return searchData;
  }
}

class Item {
  int key;
  String topicId;
  String topicTitle;
  String topicSummary;
  String topicCreateAt;
  List<NewsList> newsList;
  int topicState;
  bool hasTimeline;
  bool inContentOnly;

  Item(
      {this.key,
      this.topicId,
      this.topicTitle,
      this.topicSummary,
      this.topicCreateAt,
      this.newsList,
      this.topicState,
      this.hasTimeline,
      this.inContentOnly});

  Item.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    topicId = json['topicId'];
    topicTitle = json['topicTitle'];
    topicSummary = json['topicSummary'];
    topicCreateAt = json['topicCreateAt'];
    if (json['newsList'] != null) {
      newsList = [];
      json['newsList'].forEach((v) {
        newsList.add(new NewsList.fromJson(v));
      });
    }
    topicState = json['topicState'];
    hasTimeline = json['hasTimeline'];
    inContentOnly = json['inContentOnly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['topicId'] = this.topicId;
    data['topicTitle'] = this.topicTitle;
    data['topicSummary'] = this.topicSummary;
    data['topicCreateAt'] = this.topicCreateAt;
    if (this.newsList != null) {
      data['newsList'] = this.newsList.map((v) => v.toJson()).toList();
    }
    data['topicState'] = this.topicState;
    data['hasTimeline'] = this.hasTimeline;
    data['inContentOnly'] = this.inContentOnly;
    return data;
  }
}

class NewsList {
  String title;
  String summary;
  String url;
  bool isShow;
  String siteName;
  String publishDate;
  bool hidden;
  bool hasInstantView;
  String id;

  NewsList(
      {this.title,
      this.summary,
      this.url,
      this.isShow,
      this.siteName,
      this.publishDate,
      this.hidden,
      this.hasInstantView,
      this.id});

  NewsList.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    summary = json['summary'];
    url = json['url'];
    isShow = json['isShow'];
    siteName = json['siteName'];
    publishDate = json['publishDate'];
    hidden = json['hidden'];
    hasInstantView = json['hasInstantView'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['summary'] = this.summary;
    data['url'] = this.url;
    data['isShow'] = this.isShow;
    data['siteName'] = this.siteName;
    data['publishDate'] = this.publishDate;
    data['hidden'] = this.hidden;
    data['hasInstantView'] = this.hasInstantView;
    data['id'] = this.id;
    return data;
  }
}

class Self {
  List<EntitySuggestions> entitySuggestions;

  Self({this.entitySuggestions});

  Self.fromJson(Map<String, dynamic> json) {
    if (json['entitySuggestions'] != null) {
      entitySuggestions = [];
      json['entitySuggestions'].forEach((v) {
        entitySuggestions.add(new EntitySuggestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.entitySuggestions != null) {
      data['entitySuggestions'] =
          this.entitySuggestions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EntitySuggestions {
  String text;
  String entityType;
  String entityName;
  String entityId;
  String subType;

  EntitySuggestions(
      {this.text,
      this.entityType,
      this.entityName,
      this.entityId,
      this.subType});

  EntitySuggestions.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    entityType = json['entityType'];
    entityName = json['entityName'];
    entityId = json['entityId'];
    subType = json['subType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['entityType'] = this.entityType;
    data['entityName'] = this.entityName;
    data['entityId'] = this.entityId;
    data['subType'] = this.subType;
    return data;
  }
}
