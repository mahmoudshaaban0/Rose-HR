import 'package:json_annotation/json_annotation.dart';

part 'home_response.g.dart';

@JsonSerializable(createFactory: false)
class HomeResponse {
  HomeResponse({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return HomeResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? HomeResult.fromJson(rawResult) : null,
    );
  }
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  HomeResult? result;

  Map<String, dynamic> toJson() => _$HomeResponseToJson(this);
}

@JsonSerializable(createFactory: false)
class HomeResult {
  HomeResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory HomeResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return HomeResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: rawData is Map<String, dynamic> ? HomeData.fromJson(rawData) : null,
    );
  }

  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  HomeData? data;

  Map<String, dynamic> toJson() => _$HomeResultToJson(this);
}

@JsonSerializable()
class HomeData {
  HomeData({
    this.projectedCheckout,
    this.leaveBalances = const <LeaveBalance>[],
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => _$HomeDataFromJson(json);
  @JsonKey(name: "projected_checkout")
  dynamic projectedCheckout;
  @JsonKey(name: "leave_balances", defaultValue: <LeaveBalance>[])
  List<LeaveBalance> leaveBalances;

  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}

@JsonSerializable()
class LeaveBalance {
  LeaveBalance({
    this.label,
    this.balance,
    this.unit,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) => _$LeaveBalanceFromJson(json);
  @JsonKey(name: "label")
  String? label;
  @JsonKey(name: "balance")
  double? balance;
  @JsonKey(name: "unit")
  String? unit;

  Map<String, dynamic> toJson() => _$LeaveBalanceToJson(this);
}
