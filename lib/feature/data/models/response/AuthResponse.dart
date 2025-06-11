import 'package:json_annotation/json_annotation.dart';
part 'AuthResponse.g.dart';


@JsonSerializable()
class AuthResponse {
  final String token_type;
  final int expires_in;
  final String access_token;

  AuthResponse({required this.token_type,
    required this.expires_in,
    required this.access_token
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
}
