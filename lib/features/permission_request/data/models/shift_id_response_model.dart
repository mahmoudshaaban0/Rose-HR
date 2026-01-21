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

  factory Result.fromJson(Map<String, dynamic> json) {
    final success = json['success'] as bool?;
    final statusCode = (json['status_code'] as num?)?.toInt();
    final message = json['message'] as String?;

    // Handle data being either a List or a single Map
    List<Datum>? data;
    final rawData = json['data'];
    if (rawData is List) {
      data = rawData.map((e) => Datum.fromJson(e as Map<String, dynamic>)).toList();
    } else if (rawData is Map<String, dynamic>) {
      data = [Datum.fromJson(rawData)];
    }

    return Result(
      success: success,
      statusCode: statusCode,
      message: message,
      data: data,
    );
  }

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
    this.checkIn,
    this.checkOut,
    this.timeLateIn,
    this.timeEarlyOut,
    this.totalLateTime,
    this.totalWorkTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "hour_from")
  double? hourFrom;
  @JsonKey(name: "hour_to")
  double? hourTo;
  @JsonKey(name: "check_in")
  dynamic checkIn; // Can be false or String timestamp
  @JsonKey(name: "check_out")
  dynamic checkOut; // Can be false or String timestamp
  @JsonKey(name: "time_late_in")
  double? timeLateIn;
  @JsonKey(name: "time_early_out")
  double? timeEarlyOut;
  @JsonKey(name: "total_late_time")
  double? totalLateTime;
  @JsonKey(name: "total_work_time")
  double? totalWorkTime;

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
