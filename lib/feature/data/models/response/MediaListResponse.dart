import 'package:aninder/feature/data/models/MediaListData.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MediaListResponse {
  final MediaListData data;
  MediaListResponse({required this.data});

}