# File Upload Cubit - Practical Usage Example

This document shows a real-world example of integrating the FileUploadCubit into the Punch Correction Screen.

## Before (Without FileUploadCubit)

```dart
// Static upload area with no functionality
Text(context.localizations.attachments, style: context.typography.medium16),
DottedBorder(
  options: RoundedRectDottedBorderOptions(
    color: context.colors.dividerColor,
    radius: Radius.circular(AppSpacing.xxxxl.r),
    dashPattern: [10, 10],
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxxl.h, horizontal: AppSpacing.xxxxl.w),
    child: Center(
      child: Column(
        spacing: AppSpacing.sm.h,
        children: [
          const AppVectorGraphic(path: Assets.vectorsUploadCloud),
          Text(context.localizations.clickToUpload, style: context.typography.medium14),
          Text(context.localizations.fileFormatsHint, style: context.typography.regular14),
        ],
      ),
    ),
  ),
),
```

## After (With FileUploadCubit)

### Step 1: Add FileUploadCubit to Screen State

```dart
class _PunchCorrectionScreenState extends State<PunchCorrectionScreen> {
  late final TextEditingController _reasonController;
  late final FileUploadCubit _fileUploadCubit;  // Add this

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    _fileUploadCubit = sl<FileUploadCubit>();  // Initialize
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _fileUploadCubit.close();  // Don't forget to dispose
    super.dispose();
  }
```

### Step 2: Replace Static Upload Area with FileUploadWidget

```dart
// In the build method, replace the static upload area with:
Text(context.localizations.attachments, style: context.typography.medium16),
FileUploadWidget(
  cubit: _fileUploadCubit,
  allowMultiple: true,
  fileType: FilePickerType.both,
),
```

### Step 3: Use Attachments When Submitting

```dart
void _submitPunchCorrection(BuildContext context, PunchCorrectionState state) {
  // ... existing validation code ...

  // Get attachments from the cubit
  final attachments = _fileUploadCubit.getAttachmentsForApi();

  // Submit with attachments
  context.read<PunchCorrectionCubit>().submitPunchCorrection(
    formattedDate: formattedDate,
    reason: !reason.isNullOrEmpty ? '${state.reasonId} - $reason' : state.reasonId,
    attachments: attachments,  // Add this
  );
}
```

### Step 4: Clear Files After Successful Submission

```dart
BlocListener<PunchCorrectionCubit, PunchCorrectionState>(
  listenWhen: (previous, current) => previous.status != current.status,
  listener: (context, state) {
    if (state.status == PunchCorrectionStatus.success) {
      final result = state.punchCorrectionResponseModel?.result;
      if (result?.statusCode == 200) {
        const SuccessRequestBottomsheet().callSheet(context);
        _reasonController.clear();
        _fileUploadCubit.reset();  // Clear uploaded files
      }
    }
  },
)
```

## Complete Integration Example

Here's the complete updated `_PunchCorrectionScreenState`:

```dart
class _PunchCorrectionScreenState extends State<PunchCorrectionScreen> {
  late final TextEditingController _reasonController;
  late final FileUploadCubit _fileUploadCubit;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    _fileUploadCubit = sl<FileUploadCubit>();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _fileUploadCubit.close();
    super.dispose();
  }

  void _submitPunchCorrection(BuildContext context, PunchCorrectionState state) {
    // Validate required fields
    if (state.date == null) {
      ToastService.showError('Please select a date', gravity: ToastGravity.CENTER);
      return;
    }

    if (state.shiftId == null) {
      ToastService.showError('Please select a shift', gravity: ToastGravity.CENTER);
      return;
    }

    if (state.correctionType == null) {
      ToastService.showError('Please select correction type (In or Out)', gravity: ToastGravity.CENTER);
      return;
    }

    if (state.attendanceMethod == null) {
      ToastService.showError('Please select attendance method', gravity: ToastGravity.CENTER);
      return;
    }

    if (state.reasonId == null) {
      ToastService.showError('Please select reason', gravity: ToastGravity.CENTER);
      return;
    }

    final correctionTime = state.correctionType == CorrectionType.checkIn.id ? state.startTime : state.endTime;

    if (correctionTime == null) {
      ToastService.showError('Please select correction time', gravity: ToastGravity.CENTER);
      return;
    }

    final formattedDate = TimezoneHelper.format(
      TimezoneHelper.createTimestamp(AppTimezone.egypt, DateTime.parse(state.date!)),
      pattern: 'yyyy-MM-dd',
      locale: 'en',
    );

    final reason = _reasonController.text.trim().isEmpty ? '' : _reasonController.text.trim();

    // Get attachments from file upload cubit
    final attachments = _fileUploadCubit.getAttachmentsForApi();

    // Submit with attachments
    context.read<PunchCorrectionCubit>().submitPunchCorrection(
      formattedDate: formattedDate,
      reason: !reason.isNullOrEmpty ? '${state.reasonId} - $reason' : state.reasonId,
      attachments: attachments,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PunchCorrectionCubit>()),
        BlocProvider(create: (context) => sl<ShiftIdCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ShiftIdCubit, ShiftIdState>(
            listener: (context, state) {
              if (state.status == ShiftIdStatus.error) {
                ToastService.showError(
                  state.errorMessage ?? 'Failed to fetch shift information',
                );
              } else if (state.status == ShiftIdStatus.success) {
                final firstShift = state.shiftIdResponseModel?.result?.data?.firstOrNull;
                if (firstShift != null && firstShift.id != null) {
                  context.read<PunchCorrectionCubit>().selectShiftId(firstShift.id!);
                }
              }
            },
          ),
          BlocListener<PunchCorrectionCubit, PunchCorrectionState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == PunchCorrectionStatus.success) {
                final result = state.punchCorrectionResponseModel?.result;
                if (result?.statusCode == 200) {
                  const SuccessRequestBottomsheet().callSheet(context);
                  _reasonController.clear();
                  _fileUploadCubit.reset();  // Clear files after success
                } else {
                  ToastService.showError(
                    gravity: ToastGravity.CENTER,
                    result?.message ?? 'Failed to submit punch correction',
                  );
                }
              } else if (state.status == PunchCorrectionStatus.error) {
                ToastService.showError(
                  gravity: ToastGravity.CENTER,
                  state.errorMessage ?? 'Failed to submit punch correction',
                );
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: context.colors.containerBackground,
              appBar: PrimaryAppBar(title: context.localizations.punchCorrection),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSpacing.md.h,
                          children: [
                            // ... existing form fields ...
                            
                            // Replace static upload area with FileUploadWidget
                            Text(context.localizations.attachments, style: context.typography.medium16),
                            FileUploadWidget(
                              cubit: _fileUploadCubit,
                              allowMultiple: true,
                              fileType: FilePickerType.both,
                            ),
                            
                            SizedBox(height: AppSpacing.xxxxl.h),
                          ],
                        ),
                      ),
                    ),
                    
                    // Submit button
                    BlocBuilder<PunchCorrectionCubit, PunchCorrectionState>(
                      builder: (context, state) {
                        final isLoading = state.status == PunchCorrectionStatus.loading;
                        return isLoading
                            ? Center(
                                child: SizedBox(
                                  width: 24.r,
                                  height: 24.r,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2.r,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      context.colors.success,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                                child: PrimaryTextButton(
                                  onTap: state.date == null ||
                                          state.shiftId == null ||
                                          state.correctionType == null ||
                                          state.attendanceMethod == null ||
                                          state.reasonId == null
                                      ? null
                                      : () => _submitPunchCorrection(context, state),
                                  appButtonSize: AppButtonSize.xxLarge,
                                  label: context.localizations.submit,
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

## What You Get

With this integration, you automatically get:

✅ **File Picking** - Users can select multiple images or PDFs
✅ **Progress Indicators** - CircularProgressIndicator shows while encoding
✅ **File Type Icons** - Automatic image/PDF icon display
✅ **File Management** - Users can remove files before submission
✅ **Validation** - File size and type validation
✅ **Success Feedback** - Visual confirmation when files are ready
✅ **API Ready** - Files are automatically base64 encoded and formatted for API

## Visual Flow

1. User taps upload area → File picker opens
2. User selects files → Files appear in list with loading indicators
3. Files encode to base64 → Progress indicators show encoding progress
4. Encoding complete → Success checkmark appears with file icons
5. User submits form → Attachments sent with request
6. Success → Files cleared automatically

## Benefits

- **Reusable**: Use the same cubit in Permission Request, Punch Correction, and any other screen
- **Clean Code**: All file upload logic is centralized in the cubit
- **Type Safe**: Full type safety with Dart's type system
- **Testable**: Easy to unit test the cubit independently
- **Maintainable**: Changes to file upload logic only need to be made in one place
- **User Friendly**: Excellent UX with progress indicators and visual feedback

