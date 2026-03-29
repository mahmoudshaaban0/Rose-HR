import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

@JsonSerializable(createFactory: false)
class LoginResponseModel {
  LoginResponseModel({
    this.jsonrpc,
    this.id,
    this.loginResult,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return LoginResponseModel(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      loginResult: rawResult is Map<String, dynamic> ? LoginResult.fromJson(rawResult) : null,
    );
  }
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  LoginResult? loginResult;

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

@JsonSerializable(createFactory: false)
class LoginResult {
  LoginResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return LoginResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: rawData is Map<String, dynamic> ? Data.fromJson(rawData) : null,
    );
  }

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
