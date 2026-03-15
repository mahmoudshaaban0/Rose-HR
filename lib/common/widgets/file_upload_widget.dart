import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/cubits/file_upload/file_upload_cubit.dart';
import 'package:rose_hr/common/models/upload_file_model.dart';
import 'package:rose_hr/common/widgets/upload_source_bottom_sheet.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// Reusable file upload widget that can be used across the app
///
/// Features:
/// - Displays upload area with dotted border
/// - Shows list of uploaded files with progress indicators
/// - Supports both images and PDFs
/// - Shows appropriate icons based on file type
/// - Displays file size and upload status
class FileUploadWidget extends StatelessWidget {
  const FileUploadWidget({
    required this.cubit,
    super.key,
    this.uploadAreaTitle,
    this.uploadAreaSubtitle,
    this.allowMultiple = true,
    this.fileType = FilePickerType.both,
    this.showUploadedFiles = true,
  });

  /// The file upload cubit instance
  final FileUploadCubit cubit;

  /// Title text for upload area (e.g., "Click to upload")
  final String? uploadAreaTitle;

  /// Subtitle text for upload area (e.g., "PDF or Image (max 10MB)")
  final String? uploadAreaSubtitle;

  /// Whether to allow multiple file selection
  final bool allowMultiple;

  /// Type of files to allow
  final FilePickerType fileType;

  /// Whether to show the list of uploaded files below the upload area
  final bool showUploadedFiles;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadCubit, FileUploadState>(
      bloc: cubit,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md.h,
          children: [
            // Upload area
            _buildUploadArea(context, state),

            // List of uploaded files
            if (showUploadedFiles && state.hasFiles) ...[
              ...state.files.map((file) => _buildFileItem(context, file)),
            ],
          ],
        );
      },
    );
  }

  /// Build the upload area with dotted border
  Widget _buildUploadArea(BuildContext context, FileUploadState state) {
    return state.hasFiles
        ? const SizedBox.shrink()
        : DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: context.colors.dividerColor,
              radius: Radius.circular(AppSpacing.xxxxl.r),
              dashPattern: [10, 10],
            ),
            child: InkWell(
              onTap: state.isMaxFilesReached
                  ? null
                  : () {
                      if (fileType == FilePickerType.both) {
                        showUploadSourceSheet(
                          context,
                          onChooseImages: () => cubit.pickFiles(
                            allowMultiple: allowMultiple,
                            fileType: FilePickerType.image,
                          ),
                          onChooseFiles: () => cubit.pickFiles(
                            allowMultiple: allowMultiple,
                            fileType: FilePickerType.pdf,
                          ),
                        );
                      } else {
                        cubit.pickFiles(
                          allowMultiple: allowMultiple,
                          fileType: fileType,
                        );
                      }
                    },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSpacing.xxxxl.h,
                  horizontal: AppSpacing.xxxxl.w,
                ),
                child: Center(
                  child: Column(
                    spacing: AppSpacing.sm.h,
                    children: [
                      const AppVectorGraphic(path: Assets.vectorsUploadCloud),
                      Text(
                        uploadAreaTitle ?? context.localizations.clickToUpload,
                        style: context.typography.medium14,
                      ),
                      Text(
                        uploadAreaSubtitle ?? context.localizations.fileFormatsHint,
                        style: context.typography.regular14,
                      ),
                      if (state.isMaxFilesReached)
                        Padding(
                          padding: EdgeInsets.only(top: AppSpacing.xs.h),
                          child: Text(
                            context.localizations.maxFilesReached(state.maxFiles),
                            style: context.typography.regular12.copyWith(
                              color: context.colors.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  /// Build a single file item with progress indicator
  Widget _buildFileItem(BuildContext context, UploadFileModel file) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.md.h,
        horizontal: AppSpacing.xl.w,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffFDFAF6),
        borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
        border: Border.all(color: context.colors.dividerColor),
      ),
      child: Row(
        children: [
          // File icon or loading indicator
          _buildFileIcon(context, file),
          SizedBox(width: AppSpacing.md.w),

          // File details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: context.typography.medium16,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xxs.h),
                _buildFileStatus(context, file),
              ],
            ),
          ),

          // Delete button
          if (!file.isUploading)
            InkWell(
              onTap: () => cubit.removeFile(file.id),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xs.r),
                child: const AppVectorGraphic(
                  path: Assets.vectorsTrash,
                  width: 20,
                  height: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build file icon or loading indicator
  Widget _buildFileIcon(BuildContext context, UploadFileModel file) {
    if (file.isUploading) {
      return SizedBox(
        width: 24.r,
        height: 24.r,
        child: CircularProgressIndicator(
          strokeWidth: 2.r,
          value: file.uploadProgress,
          valueColor: AlwaysStoppedAnimation<Color>(
            context.colors.success,
          ),
        ),
      );
    }

    // Show appropriate icon based on file type
    final iconPath = file.isPdf ? Assets.vectorsPdf : Assets.vectorsImage;

    return AppVectorGraphic(
      path: iconPath,
      width: 24.r,
      height: 24.r,
    );
  }

  /// Build file status text (size and upload status)
  Widget _buildFileStatus(BuildContext context, UploadFileModel file) {
    if (file.isUploading) {
      return Row(
        spacing: AppSpacing.xs.w,
        children: [
          Text(
            '${(file.uploadProgress * 100).toInt()}%',
            style: context.typography.regular14.copyWith(
              color: context.colors.containerBorder,
            ),
          ),
          Text(
            context.localizations.uploading,
            style: context.typography.regular14.copyWith(
              color: context.colors.containerBorder,
            ),
          ),
        ],
      );
    }

    if (file.hasError) {
      return Text(
        file.errorMessage ?? context.localizations.uploadFailed,
        style: context.typography.regular14.copyWith(
          color: context.colors.error,
        ),
      );
    }

    if (file.isUploadComplete) {
      return Row(
        spacing: AppSpacing.xs.w,
        children: [
          Text(
            file.formattedSize,
            style: context.typography.regular14.copyWith(
              color: context.colors.containerBorder,
            ),
          ),
          const AppVectorGraphic(
            path: Assets.vectorsSelectBoxRight,
            width: 16,
            height: 16,
          ),
          Text(
            context.localizations.uploadedSuccessfully,
            style: context.typography.regular14,
          ),
        ],
      );
    }

    return Text(
      file.formattedSize,
      style: context.typography.regular14.copyWith(
        color: context.colors.containerBorder,
      ),
    );
  }
}
