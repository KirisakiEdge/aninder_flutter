import '../../../core/network/graphql_client.dart';
import 'general_interface.dart';

class GeneralRepository extends GeneralRepositoryInterface {
  final GraphQlClient _graphQLClient;

  GeneralRepository({required GraphQlClient graphQlClient})
      : _graphQLClient = graphQlClient;


  @override
  Future<void> getGenreTagList() {
    // TODO: implement getGenreTagList
    throw UnimplementedError();
  }

}