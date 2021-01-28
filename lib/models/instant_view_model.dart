import 'dart:convert';

class InstantViewModel {
  String url;
  String title;
  String content;
  String siteName;

  InstantViewModel({this.url, this.title, this.content, this.siteName});

  String get formatContent {
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(content));

    return 'data:text/html;base64,$contentBase64';
  }

  InstantViewModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    content = json['content'];
    siteName = json['siteName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['title'] = this.title;
    data['content'] = this.content;
    data['siteName'] = this.siteName;
    return data;
  }
}
