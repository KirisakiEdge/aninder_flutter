import 'package:json_annotation/json_annotation.dart';
part 'GenreTagListResponse.g.dart';


@JsonSerializable()
class GenreTagListResponse{
  final List<String> GenreCollection;
  final List<MediaTagsCollection> MediaTagColection;

  GenreTagListResponse({required this.GenreCollection, required this.MediaTagColection});

  factory GenreTagListResponse.fromJson(Map<String, dynamic> json) => _$GenreTagListResponseFromJson(json);

}

@JsonSerializable()
class MediaTagsCollection{
  final String name;

  MediaTagsCollection({required this.name});
  factory MediaTagsCollection.fromJson(Map<String, dynamic> json) => _$MediaTagsCollectionFromJson(json);

}