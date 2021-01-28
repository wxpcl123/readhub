// https://api.readhub.cn/news?pageSize=10&lastCursor=xxxxxx
// https://api.readhub.cn/technews?pageSize=10&lastCursor=xxxxxx
// https://api.readhub.cn/blockchain?pageSize=10&lastCursor=xxxxxx

class NewsModel {
  List<NewsData> newsDatas;
  int pageSize;
  int totalItems;
  int totalPages;

  NewsModel({this.newsDatas, this.pageSize, this.totalItems, this.totalPages});

  NewsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      newsDatas = [];
      json['data'].forEach((v) {
        newsDatas.add(new NewsData.fromJson(v));
      });
    }
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> newsData = new Map<String, dynamic>();
    if (this.newsDatas != null) {
      newsData['data'] = this.newsDatas.map((v) => v.toJson()).toList();
    }
    newsData['pageSize'] = this.pageSize;
    newsData['totalItems'] = this.totalItems;
    newsData['totalPages'] = this.totalPages;
    return newsData;
  }
}

class NewsData {
  String summary;
  int id;
  String title;
  String summaryAuto;
  String url;
  String mobileUrl;
  String siteName;
  String language;
  String authorName;
  String publishDate;

  NewsData(
      {this.summary,
      this.id,
      this.title,
      this.summaryAuto,
      this.url,
      this.mobileUrl,
      this.siteName,
      this.language,
      this.authorName,
      this.publishDate});

  NewsData.fromJson(Map<String, dynamic> json) {
    summary = json['summary'];
    id = json['id'];
    title = json['title'];
    summaryAuto = json['summaryAuto'];
    url = json['url'];
    mobileUrl = json['mobileUrl'];
    siteName = json['siteName'];
    language = json['language'];
    authorName = json['authorName'];
    publishDate = json['publishDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['summary'] = this.summary;
    data['id'] = this.id;
    data['title'] = this.title;
    data['summaryAuto'] = this.summaryAuto;
    data['url'] = this.url;
    data['mobileUrl'] = this.mobileUrl;
    data['siteName'] = this.siteName;
    data['language'] = this.language;
    data['authorName'] = this.authorName;
    data['publishDate'] = this.publishDate;
    return data;
  }
}
