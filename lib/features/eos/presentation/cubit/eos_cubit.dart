import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/models/upload_file_model.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/account/data/repositories/account_repository.dart';
import 'package:rose_hr/features/eos/data/models/eos_request_model.dart';
import 'package:rose_hr/features/eos/data/models/eos_response_model.dart';
import 'package:rose_hr/features/eos/data/repositories/eos_repository.dart';

part 'eos_state.dart';

/// Allowed values for the `resignation_reason` API field.
enum ResignationReason {
  resignation('resignation'),
  termination('termination');

  const ResignationReason(this.value);
  final String value;
}

class EosCubit extends Cubit<EosState> {
  EosCubit(this.eosRepository, this.accountRepository) : super(const EosState());

  final EosRepository eosRepository;
  final AccountRepository accountRepository;

  /// Loads the employee nationality to decide which resignation reasons apply.
  ///
  /// Saudi employees may only submit a `resignation`; any other nationality may
  /// choose between `resignation` and `termination`. The reason always defaults
  /// to `resignation`.
  Future<void> loadNationality() async {
    if (isClosed) return;
    emit(state.copyWith(status: EosStatus.loading));
    final result = await accountRepository.getAccountInfo();
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        final country = data.result?.data?.country?.toString() ?? '';
        final isSaudi = _isSaudi(country);
        emit(state.copyWith(status: EosStatus.success, isSaudi: isSaudi));
      case Error(:final failure):
        if (isClosed) return;
        // Even if we fail to resolve nationality, keep the screen usable with
        // the safe default (resignation only is not assumed; show both).
        emit(state.copyWith(status: EosStatus.error, errorMessage: failure.message));
    }
  }

  bool _isSaudi(String country) {
    final normalized = country.toLowerCase();
    return normalized.contains('saudi') || country.contains('السعود');
  }

  void selectLastWorkingDay(DateTime date) {
    if (isClosed) return;
    emit(state.copyWith(lastWorkingDay: date.toIso8601String()));
  }

  void selectResignationReason(ResignationReason reason) {
    if (isClosed) return;
    emit(state.copyWith(resignationReason: reason));
  }

  void updateReasonDetail(String detail) {
    if (isClosed) return;
    emit(state.copyWith(resignationReasonDetail: detail.isEmpty ? null : detail));
  }

  Future<void> submitEos(List<UploadFileModel> files) async {
    if (isClosed) return;
    emit(state.copyWith(status: EosStatus.submitting));

    try {
      if (state.lastWorkingDay == null) {
        emit(
          state.copyWith(
            status: EosStatus.submitError,
            errorMessage: 'pleaseSelectLastWorkingDay',
          ),
        );
        return;
      }

      final formattedLastWorkingDay = TimezoneHelper.format(
        TimezoneHelper.createTimestamp(
          DateTime.parse(state.lastWorkingDay!),
        ),
        pattern: 'yyyy-MM-dd',
        locale: 'en',
      );

      List<EosAttachmentModel>? attachments;
      if (files.isNotEmpty) {
        attachments = files.map((file) {
          return EosAttachmentModel(
            mimetype: file.mimeType,
            name: file.name,
            data: file.base64Data ?? '',
          );
        }).toList();
      }

      final request = EosRequestModel(
        params: EosRequestParams(
          lastWorkingDay: formattedLastWorkingDay,
          resignationReason: state.resignationReason.value,
          resignationReasonDetail: state.resignationReasonDetail,
          attachments: attachments,
        ),
      );

      final result = await eosRepository.createEos(request);

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          emit(
            state.copyWith(
              status: EosStatus.submitted,
              eosResponseModel: data,
            ),
          );
        case Error(:final failure):
          emit(
            state.copyWith(
              status: EosStatus.submitError,
              errorMessage: failure.message,
            ),
          );
      }
    } on Exception catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: EosStatus.submitError,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
