import 'package:json_annotation/json_annotation.dart';

part 'shift_id_response_model.g.dart';

@JsonSerializable()
class ShiftIdResponseModel {
  ShiftIdResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory ShiftIdResponseModel.fromJson(Map<String, dynamic> json) => _$ShiftIdResponseModelFromJson(json);
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  Result? result;

  Map<String, dynamic> toJson() => _$ShiftIdResponseModelToJson(this);
}

@JsonSerializable()
class Result {
  Result({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  List<Datum>? data;

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Datum {
  Datum({
    this.id,
    this.name,
    this.hourFrom,
    this.hourTo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "hour_from")
  int? hourFrom;
  @JsonKey(name: "hour_to")
  int? hourTo;

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
