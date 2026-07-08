# Punch Correction Request Examples

## Overview
The punch correction feature allows employees to request corrections to their attendance records. There are two methods for correction:
1. **Manual**: Manually specify the correction time
2. **Attendance Log**: Use an existing attendance log entry

## Request Structure

### Required Fields (All Methods)
- `date`: Date of the attendance to fix (YYYY-MM-DD format)
- `shift_id`: Shift ID (integer)
- `correction_type`: Type of correction - `'in'`, `'out'` or `'both'`
- `fix_attendance_method`: Method to use - either `'manual'` or `'attendance_log'`

### Optional Fields
- `reason`: Reason for the correction request (string)
- `attachment_ids`: List of attachments (array of objects with name, data, mimetype)

### Method-Specific Fields

#### Manual Method
- `correction_time`: The corrected time in float hours (e.g., 18.0 for 6:00 PM). For `correction_type: 'both'` this is the check-in time.
- `correction_time_out`: The corrected check-out time in float hours. Sent only when `correction_type: 'both'`.

#### Attendance Log Method
- `attendance_log_id`: ID of the attendance log entry to use (integer). For `correction_type: 'both'` this is the check-in log.
- `attendance_log_out_id`: ID of the check-out attendance log entry. Sent only when `correction_type: 'both'`.

## Usage Examples

### Example 1: Manual Method (Check-Out Correction)

```dart
import 'package:rose_hr/features/punch_correction/data/models/punch_correction_request_model.dart';

// Create a manual punch correction request
final request = PunchCorrectionRequestModel.manual(
  date: "2026-01-15",
  shiftId: 58,
  correctionType: "out",
  correctionTime: 18.0, // 6:00 PM
  reason: "Forgot to punch out",
);

// Submit via cubit
await punchCorrectionCubit.submitPunchCorrection(
  reason: "Forgot to punch out",
);
```

### Example 2: Attendance Log Method (Check-In Correction)

```dart
import 'package:rose_hr/features/punch_correction/data/models/punch_correction_request_model.dart';

// Create an attendance log punch correction request
final request = PunchCorrectionRequestModel.attendanceLog(
  date: "2026-01-15",
  shiftId: 58,
  correctionType: "in",
  attendanceLogId: 255,
  reason: "Used wrong attendance log",
);

// Submit via cubit
await punchCorrectionCubit.submitPunchCorrection(
  reason: "Used wrong attendance log",
);
```

### Example 3: With Attachments

```dart
import 'package:rose_hr/features/permission_request/data/models/permission_request_model.dart';
import 'package:rose_hr/features/punch_correction/data/models/punch_correction_request_model.dart';

// Create attachments
final attachments = [
  AttachmentData(
    name: "proof.pdf",
    data: base64EncodedData,
    mimetype: "application/pdf",
  ),
];

// Create request with attachments
final request = PunchCorrectionRequestModel.manual(
  date: "2026-01-15",
  shiftId: 58,
  correctionType: "out",
  correctionTime: 18.0,
  reason: "Forgot to punch out - see attached proof",
  attachmentIds: attachments,
);

// Submit via cubit
await punchCorrectionCubit.submitPunchCorrection(
  reason: "Forgot to punch out - see attached proof",
  attachmentIds: attachments,
);
```

## Using the Cubit

### Setting Up State

```dart
// Select date
punchCorrectionCubit.selectDate(DateTime(2026, 1, 15));

// Select shift ID
punchCorrectionCubit.selectShiftId(58);

// Select correction type via the two independent toggles. Enabling both
// produces correction_type 'both'; enabling one produces 'in' or 'out'.
punchCorrectionCubit.toggleCheckIn(true);
punchCorrectionCubit.toggleCheckOut(true);

// Select attendance method ('manual' or 'attendance_log')
punchCorrectionCubit.selectAttendanceMethod('manual');

// Tell the correction-time screen which slot it is editing ('in' or 'out')
punchCorrectionCubit.setEditingType('in');

// For manual method: set correction time (check-in -> startTime, check-out -> endTime)
punchCorrectionCubit.selectStartTime(8.72); // check-in
punchCorrectionCubit.selectEndTime(17.0);   // check-out

// For attendance_log method: the picked log is stored in the slot named by
// setEditingType (in -> attendanceLogId, out -> attendanceLogOutId)
punchCorrectionCubit.selectLogTime(8.72, 255);
```

### Submitting the Request

```dart
// Submit the punch correction
await punchCorrectionCubit.submitPunchCorrection(
  reason: "Your reason here",
  attachmentIds: optionalAttachments,
);

// Listen to state changes
BlocListener<PunchCorrectionCubit, PunchCorrectionState>(
  listener: (context, state) {
    if (state.status == PunchCorrectionStatus.success) {
      // Handle success
      print('Punch correction submitted successfully');
    } else if (state.status == PunchCorrectionStatus.error) {
      // Handle error
      print('Error: ${state.errorMessage}');
    }
  },
  child: YourWidget(),
)
```

## JSON Request Format

### Manual Method
```json
{
  "params": {
    "date": "2026-01-15",
    "shift_id": 58,
    "correction_type": "out",
    "fix_attendance_method": "manual",
    "correction_time": 18.0,
    "reason": "Reason for correction",
    "attachment_ids": []
  }
}
```

### Attendance Log Method
```json
{
  "params": {
    "date": "2026-01-15",
    "shift_id": 58,
    "correction_type": "out",
    "fix_attendance_method": "attendance_log",
    "attendance_log_id": 255,
    "reason": "Reason for correction",
    "attachment_ids": []
  }
}
```

### Both (In + Out) — Manual Method
```json
{
  "params": {
    "date": "2026-07-01",
    "shift_id": 4479,
    "correction_type": "both",
    "fix_attendance_method": "manual",
    "correction_time": 8.72,
    "correction_time_out": 17.0,
    "reason": "Reason for correction",
    "attachment_ids": []
  }
}
```

### Both (In + Out) — Attendance Log Method
```json
{
  "params": {
    "date": "2026-07-01",
    "shift_id": 4479,
    "correction_type": "both",
    "fix_attendance_method": "attendance_log",
    "attendance_log_id": 255,
    "attendance_log_out_id": 321,
    "reason": "Reason for correction",
    "attachment_ids": []
  }
}
```

## Response Structure

The API returns a `PunchCorrectionResponseModel` with the following structure:

```dart
class PunchCorrectionResponseModel {
  String? jsonrpc;
  dynamic id;
  PunchCorrectionResult? result;
}

class PunchCorrectionResult {
  bool? success;
  int? statusCode;
  String? message;
  PunchCorrectionData? data;
}

class PunchCorrectionData {
  int? id;
  String? name;
  int? employeeId;
  String? employeeName;
  String? correctionType;
  String? correctionTypeDisplay;
  DateTime? date;
  double? correctionTime;
  int? attendanceLogId;
  String? reason;
  String? state;
  String? stateDisplay;
  int? managerId;
  String? managerName;
  int? resAttendanceId;
  String? shiftName;
  String? fixAttendanceMethod;
}
```

