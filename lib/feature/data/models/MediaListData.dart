import 'package:json_annotation/json_annotation.dart';

import 'Page.dart';

@JsonSerializable()
class MediaListData {
  final Page page;

  MediaListData({required this.page});

}