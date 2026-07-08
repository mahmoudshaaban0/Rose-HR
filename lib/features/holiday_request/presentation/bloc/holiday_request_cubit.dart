import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/models/upload_file_model.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/holiday_request/data/models/get_all_leave_types_response_model.dart';
import 'package:rose_hr/features/holiday_request/data/models/holiday_request_model.dart';
import 'package:rose_hr/features/holiday_request/data/models/holiday_request_response_model.dart';
import 'package:rose_hr/features/holiday_request/data/models/leave_type_technical.dart';
import 'package:rose_hr/features/holiday_request/data/repositories/holiday_request_repository.dart';

part 'holiday_request_state.dart';

class HolidayRequestCubit extends Cubit<HolidayRequestState> {
  HolidayRequestCubit(this.holidayRequestRepository) : super(const HolidayRequestState());

  Future<void> getAllLeaveTypes() async {
    if (isClosed) return;
    emit(state.copyWith(status: HolidayRequestStatus.loading));
    final result = await holidayRequestRepository.getAllLeaveTypes();
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(state.copyWith(status: HolidayRequestStatus.success, leaveTypesResponseModel: data));
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(status: HolidayRequestStatus.error, errorMessage: failure.message));
    }
  }

  void selectLeaveType(
    String leaveTypeName,
    int leaveTypeId, [
    String? technicalName,
  ]) {
    // Check if the selected leave type is annual leave
    final isAnnualLeave = LeaveTypeTechnical.isAnnual(technicalName);

    // If not annual leave, reset the switches to false
    if (!isAnnualLeave) {
      emit(
        state.copyWith(
          selectedLeaveTypeName: leaveTypeName,
          selectedLeaveTypeId: leaveTypeId,
          selectedLeaveTypeTechnicalName: technicalName,
          advanceSalary: false,
          airTicket: false,
          compensationForDay: null,
        ),
      );
    } else {
      if (isClosed) return;
      emit(
        state.copyWith(
          selectedLeaveTypeName: leaveTypeName,
          selectedLeaveTypeId: leaveTypeId,
          selectedLeaveTypeTechnicalName: technicalName,
          compensationForDay: null,
        ),
      );
    }
  }

  void selectStartDate(DateTime date) {
    if (isClosed) return;
    final updatedStartDate = date.toIso8601String();

    // Keep the date range valid if the start date moves after the selected end date.
    if (state.endDate != null) {
      final currentEndDate = DateTime.parse(state.endDate!);
      if (currentEndDate.isBefore(date)) {
        emit(
          state.copyWith(
            startDate: updatedStartDate,
            endDate: updatedStartDate,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(startDate: updatedStartDate));
  }

  void selectEndDate(DateTime date) {
    if (isClosed) return;
    emit(state.copyWith(endDate: date.toIso8601String()));
  }

  void toggleAdvanceSalary(bool value) {
    if (isClosed) return;
    emit(state.copyWith(advanceSalary: value));
  }

  void toggleAirTicket(bool value) {
    // If disabling air ticket, reset all visa-related data
    if (!value) {
      if (isClosed) return;
      emit(
        state.copyWith(
          airTicket: value,
          visaTypeName: null,
          visaTypeId: null,
          visaPeriod: null,
          visaDate: null,
        ),
      );
    } else {
      if (isClosed) return;
      emit(state.copyWith(airTicket: value));
    }
  }

  void selectVisaType(String visaTypeName, String visaTypeId) {
    if (isClosed) return;
    emit(state.copyWith(visaTypeName: visaTypeName, visaTypeId: visaTypeId));
  }

  void selectVisaPeriod(String period) {
    if (isClosed) return;
    emit(state.copyWith(visaPeriod: period));
  }

  void selectVisaDate(DateTime date) {
    if (isClosed) return;
    emit(state.copyWith(visaDate: date.toIso8601String()));
  }

  void selectCompensationForDay(DateTime date) {
    if (isClosed) return;
    emit(state.copyWith(compensationForDay: date.toIso8601String()));
  }

  void updateDescription(String description) {
    if (isClosed) return;
    emit(state.copyWith(description: description.isEmpty ? null : description));
  }

  Future<void> submitHolidayRequest(List<UploadFileModel> files) async {
    if (isClosed) return;
    emit(state.copyWith(status: HolidayRequestStatus.submitting));

    try {
      // Validate required fields
      if (state.selectedLeaveTypeId == null) {
        emit(
          state.copyWith(
            status: HolidayRequestStatus.submitError,
            errorMessage: 'pleaseSelectLeaveTypeError',
          ),
        );
        return;
      }

      if (state.startDate == null || state.endDate == null) {
        emit(
          state.copyWith(
            status: HolidayRequestStatus.submitError,
            errorMessage: 'pleaseSelectHolidayDatesError',
          ),
        );
        return;
      }

      if (DateTime.parse(state.endDate!).isBefore(DateTime.parse(state.startDate!))) {
        emit(
          state.copyWith(
            status: HolidayRequestStatus.submitError,
            errorMessage: 'pleaseSelectHolidayDatesError',
          ),
        );
        return;
      }

      // Validate compensation day for compensatory leave
      final isCompensatoryLeave =
          LeaveTypeTechnical.isCompensatory(state.selectedLeaveTypeTechnicalName);

      if (isCompensatoryLeave && state.compensationForDay == null) {
        emit(
          state.copyWith(
            status: HolidayRequestStatus.submitError,
            errorMessage: 'pleaseSelectCompensationDay',
          ),
        );
        return;
      }

      // Format dates as yyyy-MM-dd
      final formattedStartDate = TimezoneHelper.format(
        TimezoneHelper.createTimestamp(
          DateTime.parse(state.startDate!),
        ),
        pattern: 'yyyy-MM-dd',
        locale: 'en',
      );

      final formattedEndDate = TimezoneHelper.format(
        TimezoneHelper.createTimestamp(
          DateTime.parse(state.endDate!),
        ),
        pattern: 'yyyy-MM-dd',
        locale: 'en',
      );

      // Format visa date if provided
      String? formattedVisaDate;
      if (state.airTicket && state.visaDate != null) {
        formattedVisaDate = TimezoneHelper.format(
          TimezoneHelper.createTimestamp(
            DateTime.parse(state.visaDate!),
          ),
          pattern: 'yyyy-MM-dd',
          locale: 'en',
        );
      }

      // Format compensation day if provided
      String? formattedCompensationForDay;
      if (state.compensationForDay != null) {
        formattedCompensationForDay = TimezoneHelper.format(
          TimezoneHelper.createTimestamp(
            DateTime.parse(state.compensationForDay!),
          ),
          pattern: 'yyyy-MM-dd',
          locale: 'en',
        );
      }

      // Prepare attachments from uploaded files
      List<AttachmentModel>? attachments;
      if (files.isNotEmpty) {
        attachments = files.map((file) {
          return AttachmentModel(
            mimetype: file.mimeType,
            name: file.name,
            data: file.base64Data ?? '',
          );
        }).toList();
      }

      // Create request model
      final request = HolidayRequestModel(
        params: HolidayRequestParams(
          leaveTypeId: state.selectedLeaveTypeId!,
          dateFrom: formattedStartDate,
          dateTo: formattedEndDate,
          requireAdvanceSalary: state.advanceSalary,
          requireExitEntryVisa: state.airTicket,
          description: state.description,
          visaType: state.airTicket ? state.visaTypeId : null,
          visaPeriod: state.airTicket ? state.visaPeriod : null,
          visaNeededBefore: formattedVisaDate,
          attachmentIds: attachments,
          compensationForDay: formattedCompensationForDay,
        ),
      );

      // Submit request
      final result = await holidayRequestRepository.createHolidayRequest(request);

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          emit(
            state.copyWith(
              status: HolidayRequestStatus.submitted,
              holidayRequestResponseModel: data,
            ),
          );
        case Error(:final failure):
          emit(
            state.copyWith(
              status: HolidayRequestStatus.submitError,
              errorMessage: failure.message,
            ),
          );
      }
    } on Exception catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: HolidayRequestStatus.submitError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  final HolidayRequestRepository holidayRequestRepository;
}
