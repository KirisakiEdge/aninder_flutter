import 'package:aninder/graphql/get_genre_tag_list.graphql.dart';
import 'package:graphql/client.dart';

import '../../../core/network/graphql_client.dart';
import 'general_interface.dart';

class GeneralRepository extends GeneralRepositoryInterface {
  final GraphQlClient _graphQLClient;

  GeneralRepository({required GraphQlClient graphQlClient})
      : _graphQLClient = graphQlClient;


  @override
  Future<Query$GetGenreAndTagLists?> getGenreTagList() async {
    final result = await _graphQLClient.client.query(
      QueryOptions(
        document: documentNodeQueryGetGenreAndTagLists,
        parserFn: (json) => Query$GetGenreAndTagLists.fromJson(json),
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final data = result.parsedData;
    return data;
  }

}