import 'package:json_annotation/json_annotation.dart';

part 'AuthRequest.g.dart';

@JsonSerializable()
class AuthRequest {
  final String grant_type;
  final int client_id;
  final String client_secret;
  final String redirect_uri;
  final String code;

  AuthRequest({
    this.grant_type = "authorization_code",
    this.client_id = 24154,
    this.client_secret = "CrdbaOnHJ5o5EXhYNs9XqlA6TuWK5IIsnRPDgbZ0",
    this.redirect_uri = "aninder://callback",
    required this.code,
  });

  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);
}