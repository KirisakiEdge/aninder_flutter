import 'package:graphql/client.dart';

import '../../feature/data/datasources/auth_local_data_source.dart';

class GraphQlClient {
  final GraphQLClient client;

  GraphQlClient._(this.client); // private named constructor

  static Future<GraphQlClient> create({required AuthLocalDataSource storage}) async {
    final token = await storage.getToken();
    final client = GraphQLClient(
      link: HttpLink(
        'https://graphql.anilist.co',
        defaultHeaders: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
      cache: GraphQLCache(store: InMemoryStore()),
    );
    return GraphQlClient._(client);
  }
}
