import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  LoginResponseModel({
    this.jsonrpc,
    this.id,
    this.loginResult,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  LoginResult? loginResult;

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

@JsonSerializable()
class LoginResult {
  LoginResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) => _$LoginResultFromJson(json);
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Data? data;

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    this.uid,
    this.name,
    this.email,
    this.apiKey,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  @JsonKey(name: "uid")
  int? uid;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "api_key")
  String? apiKey;

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
