import 'package:json_annotation/json_annotation.dart';

part 'permission_request_model.g.dart';

/// Request model for creating a permission request
/// Supports three types: 'late_in', 'early_out', 'mid_day'
@JsonSerializable(includeIfNull: false)
class PermissionRequestRequestModel {
  PermissionRequestRequestModel({
    required this.requestType,
    required this.date,
    required this.shiftId,
    this.timeFrom,
    this.timeTo,
    this.partialExcuse,
    this.requestedDuration,
    this.reason,
    this.attachmentIds,
  });

  factory PermissionRequestRequestModel.fromJson(Map<String, dynamic> json) => _$PermissionRequestRequestModelFromJson(json);

  /// Factory constructor for 'mid_day' request
  factory PermissionRequestRequestModel.midDay({
    required String date,
    required int shiftId,
    required double timeFrom,
    required double timeTo,
    String? reason,
    List<AttachmentData>? attachmentIds,
  }) {
    return PermissionRequestRequestModel(
      requestType: 'mid_day',
      date: date,
      shiftId: shiftId,
      timeFrom: timeFrom,
      timeTo: timeTo,
      reason: reason,
      attachmentIds: attachmentIds,
    );
  }

  /// Factory constructor for 'late_in' request
  factory PermissionRequestRequestModel.lateIn({
    required String date,
    required int shiftId,
    required bool partialExcuse,
    required double requestedDuration,
    String? reason,
    List<AttachmentData>? attachmentIds,
  }) {
    return PermissionRequestRequestModel(
      requestType: 'late_in',
      date: date,
      shiftId: shiftId,
      partialExcuse: partialExcuse,
      requestedDuration: requestedDuration,
      reason: reason,
      attachmentIds: attachmentIds,
    );
  }

  /// Factory constructor for 'early_out' request
  factory PermissionRequestRequestModel.earlyOut({
    required String date,
    required int shiftId,
    required bool partialExcuse,
    required double requestedDuration,
    String? reason,
    List<AttachmentData>? attachmentIds,
  }) {
    return PermissionRequestRequestModel(
      requestType: 'early_out',
      date: date,
      shiftId: shiftId,
      partialExcuse: partialExcuse,
      requestedDuration: requestedDuration,
      reason: reason,
      attachmentIds: attachmentIds,
    );
  }

  /// Request type: 'late_in', 'early_out', or 'mid_day'
  @JsonKey(name: 'request_type')
  final String requestType;

  /// Date of the request (YYYY-MM-DD format)
  @JsonKey(name: 'date')
  final String date;

  /// Shift ID
  @JsonKey(name: 'shift_id')
  final int shiftId;

  /// For mid_day: Start time (float hours)
  /// Example: 9.5 represents 9:30 AM
  @JsonKey(name: 'time_from')
  final double? timeFrom;

  /// For mid_day: End time (float hours)
  /// Example: 14.5 represents 2:30 PM
  @JsonKey(name: 'time_to')
  final double? timeTo;

  /// Required with 'late_in' or 'early_out'
  /// Indicates if this is a partial excuse
  @JsonKey(name: 'partial_excuse')
  final bool? partialExcuse;

  /// Duration to excuse (float hours)
  /// Required if partial_excuse is true
  /// Example: 0.5 represents 30 minutes
  @JsonKey(name: 'requested_duration')
  final double? requestedDuration;

  /// Reason for the request (Optional)
  @JsonKey(name: 'reason')
  final String? reason;

  /// List of attachment IDs (Optional)
  /// Each attachment should have: {name, data, mimetype}
  @JsonKey(name: 'attachment_ids')
  final List<AttachmentData>? attachmentIds;

  Map<String, dynamic> toJson() => _$PermissionRequestRequestModelToJson(this);

  PermissionRequestRequestModel copyWith({
    String? requestType,
    String? date,
    int? shiftId,
    double? timeFrom,
    double? timeTo,
    bool? partialExcuse,
    double? requestedDuration,
    String? reason,
    List<AttachmentData>? attachmentIds,
  }) {
    return PermissionRequestRequestModel(
      requestType: requestType ?? this.requestType,
      date: date ?? this.date,
      shiftId: shiftId ?? this.shiftId,
      timeFrom: timeFrom ?? this.timeFrom,
      timeTo: timeTo ?? this.timeTo,
      partialExcuse: partialExcuse ?? this.partialExcuse,
      requestedDuration: requestedDuration ?? this.requestedDuration,
      reason: reason ?? this.reason,
      attachmentIds: attachmentIds ?? this.attachmentIds,
    );
  }
}

/// Attachment data model
@JsonSerializable()
class AttachmentData {
  AttachmentData({
    required this.name,
    required this.data,
    required this.mimetype,
  });

  factory AttachmentData.fromJson(Map<String, dynamic> json) => _$AttachmentDataFromJson(json);

  /// File name
  @JsonKey(name: 'name')
  final String name;

  /// Base64 encoded file data
  @JsonKey(name: 'data')
  final String data;

  /// MIME type (e.g., 'image/png', 'application/pdf')
  @JsonKey(name: 'mimetype')
  final String mimetype;

  Map<String, dynamic> toJson() => _$AttachmentDataToJson(this);

  AttachmentData copyWith({
    String? name,
    String? data,
    String? mimetype,
  }) {
    return AttachmentData(
      name: name ?? this.name,
      data: data ?? this.data,
      mimetype: mimetype ?? this.mimetype,
    );
  }
}
