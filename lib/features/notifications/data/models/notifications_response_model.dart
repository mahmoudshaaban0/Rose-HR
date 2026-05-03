class NotificationsResponseModel {
  NotificationsResponseModel({this.jsonrpc, this.id, this.result});

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return NotificationsResponseModel(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? NotificationsResult.fromJson(rawResult) : null,
    );
  }

  final String? jsonrpc;
  final dynamic id;
  final NotificationsResult? result;
}

class NotificationsResult {
  NotificationsResult({this.success, this.statusCode, this.message, this.data});

  factory NotificationsResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return NotificationsResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: rawData is Map<String, dynamic> ? NotificationsData.fromJson(rawData) : null,
    );
  }

  final bool? success;
  final int? statusCode;
  final String? message;
  final NotificationsData? data;
}

class NotificationsData {
  NotificationsData({this.notifications, this.total});

  factory NotificationsData.fromJson(Map<String, dynamic> json) {
    final rawList = json['notifications'];
    return NotificationsData(
      notifications: rawList is List
          ? rawList
                .whereType<Map<String, dynamic>>()
                .map(NotificationItem.fromJson)
                .toList()
          : <NotificationItem>[],
      total: (json['total'] as num?)?.toInt(),
    );
  }

  final List<NotificationItem>? notifications;
  final int? total;
}

class NotificationItem {
  NotificationItem({this.title, this.body, this.sentDate});

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final rawDate = json['sent_date'] as String?;
    return NotificationItem(
      title: json['title'] as String?,
      body: json['body'] as String?,
      sentDate: _parseUtc(rawDate),
    );
  }

  static DateTime? _parseUtc(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final hasTzInfo = raw.endsWith('Z') ||
        RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(raw);
    final normalized = hasTzInfo ? raw : '${raw}Z';
    return DateTime.tryParse(normalized);
  }

  final String? title;
  final String? body;
  final DateTime? sentDate;
}
