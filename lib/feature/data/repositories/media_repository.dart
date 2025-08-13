import 'package:aninder/core/network/graphql_client.dart';
import 'package:aninder/graphql/get_media_list.graphql.dart';
import 'package:graphql/client.dart';
import 'media_interface.dart';

class MediaRepository extends MediaRepositoryInterface {
  final GraphQlClient _graphQLClient;

  MediaRepository({required GraphQlClient graphQlClient})
      : _graphQLClient = graphQlClient;

  @override
  Future<Query$GetMediaListByYear?> getMediaListByYear(
      int year, List<String> selectedGenres, List<String> selectedTags) async {
    final result = await _graphQLClient.client.query(
      QueryOptions(
        document: documentNodeQueryGetMediaListByYear,
        variables: Variables$Query$GetMediaListByYear(
          year: year,
          genre_in: selectedGenres.isEmpty ? null : selectedGenres,
          tag_in: selectedTags.isEmpty ? null : selectedTags,
        ).toJson(),
        parserFn: (json) => Query$GetMediaListByYear.fromJson(json),
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final data = result.parsedData;
    return data;
  }
}

class MediaException implements Exception {
  final String code;

  MediaException(this.code);
}
