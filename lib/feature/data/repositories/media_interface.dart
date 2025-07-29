import "../../../graphql/get_media_list.graphql.dart";
abstract class MediaRepositoryInterface {
  Future<Query$GetMediaListByYear?> getMediaListByYear(int year,List<String> selectedGenres, List<String> selectedTags);
}