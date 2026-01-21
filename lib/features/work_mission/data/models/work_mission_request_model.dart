import 'package:json_annotation/json_annotation.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_model.dart';

part 'work_mission_request_model.g.dart';

/// Request model for creating a work mission request
/// Supports two types: 'hours' and 'days'
///
/// Example for 'hours' type:
/// ```dart
/// final request = WorkMissionRequestModel.hours(
///   date: '2026-01-18',
///   shiftId: 61,
///   timeFrom: 10.0,
///   timeTo: 12.0,
///   attachmentIds: [
///     AttachmentData(
///       name: 'document.png',
///       data: 'base64EncodedData...',
///       mimetype: 'image/png',
///     ),
///   ],
///   reason: 'Client meeting',
/// );
/// ```
///
/// Example for 'days' type:
/// ```dart
/// final request = WorkMissionRequestModel.days(
///   missionStartDate: '2026-01-14',
///   missionEndDate: '2026-01-15',
///   attachmentIds: [
///     AttachmentData(
///       name: 'travel-document.pdf',
///       data: 'base64EncodedData...',
///       mimetype: 'application/pdf',
///     ),
///   ],
///   reason: 'Business trip to Dubai',
/// );
/// ```
@JsonSerializable(createToJson: true, createFactory: true, includeIfNull: false)
class WorkMissionRequestModel {
  WorkMissionRequestModel({
    required this.workMissionType,
    required this.attachmentIds,
    this.date,
    this.shiftId,
    this.timeFrom,
    this.timeTo,
    this.missionStartDate,
    this.missionEndDate,
    this.reason,
  });

  factory WorkMissionRequestModel.fromJson(Map<String, dynamic> json) => _$WorkMissionRequestModelFromJson(json);

  /// Factory constructor for 'hours' type work mission
  factory WorkMissionRequestModel.hours({
    required String date,
    required int shiftId,
    required double timeFrom,
    required double timeTo,
    required List<AttachmentData> attachmentIds,
    String? reason,
  }) {
    return WorkMissionRequestModel(
      workMissionType: 'hours',
      date: date,
      shiftId: shiftId,
      timeFrom: timeFrom,
      timeTo: timeTo,
      attachmentIds: attachmentIds,
      reason: reason,
    );
  }

  /// Factory constructor for 'days' type work mission
  factory WorkMissionRequestModel.days({
    required String missionStartDate,
    required String missionEndDate,
    required List<AttachmentData> attachmentIds,
    String? reason,
  }) {
    return WorkMissionRequestModel(
      workMissionType: 'days',
      missionStartDate: missionStartDate,
      missionEndDate: missionEndDate,
      attachmentIds: attachmentIds,
      reason: reason,
    );
  }

  /// Work mission type: 'hours' or 'days'
  @JsonKey(name: 'work_mission_type')
  final String workMissionType;

  /// For hours type: Date of the mission (YYYY-MM-DD format)
  @JsonKey(name: 'date')
  final String? date;

  /// For hours type: Shift ID
  @JsonKey(name: 'shift_id')
  final int? shiftId;

  /// For hours type: Start time (float hours)
  /// Example: 10.0 represents 10:00 AM, 10.5 represents 10:30 AM
  @JsonKey(name: 'time_from')
  final double? timeFrom;

  /// For hours type: End time (float hours)
  /// Example: 12.0 represents 12:00 PM, 14.5 represents 2:30 PM
  @JsonKey(name: 'time_to')
  final double? timeTo;

  /// For days type: Mission start date (YYYY-MM-DD format)
  @JsonKey(name: 'mission_start_date')
  final String? missionStartDate;

  /// For days type: Mission end date (YYYY-MM-DD format)
  @JsonKey(name: 'mission_end_date')
  final String? missionEndDate;

  /// Reason for the work mission (Optional)
  @JsonKey(name: 'reason')
  final String? reason;

  /// List of attachments (Required)
  /// Each attachment should have: {name, data, mimetype}
  @JsonKey(name: 'attachment_ids')
  final List<AttachmentData> attachmentIds;

  Map<String, dynamic> toJson() => _$WorkMissionRequestModelToJson(this);

  WorkMissionRequestModel copyWith({
    String? workMissionType,
    String? date,
    int? shiftId,
    double? timeFrom,
    double? timeTo,
    String? missionStartDate,
    String? missionEndDate,
    String? reason,
    List<AttachmentData>? attachmentIds,
  }) {
    return WorkMissionRequestModel(
      workMissionType: workMissionType ?? this.workMissionType,
      date: date ?? this.date,
      shiftId: shiftId ?? this.shiftId,
      timeFrom: timeFrom ?? this.timeFrom,
      timeTo: timeTo ?? this.timeTo,
      missionStartDate: missionStartDate ?? this.missionStartDate,
      missionEndDate: missionEndDate ?? this.missionEndDate,
      reason: reason ?? this.reason,
      attachmentIds: attachmentIds ?? this.attachmentIds,
    );
  }
}
