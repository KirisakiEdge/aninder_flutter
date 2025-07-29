import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Page {
  final List<List> media;

  Page({required this.media});

}