import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/attachment_viewer_screen.dart';
import 'package:rose_hr/common/widgets/file_upload_widget.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/requests/data/models/single_request_response_by_id.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// Read-only attachment list — mirrors the visual style of [FileUploadWidget]
/// but only shows items, no upload/delete interactions.
/// Tapping an item opens it in-app: images via photo_view, PDFs via SfPdfViewer.
class AttachmentViewerWidget extends StatelessWidget {
  const AttachmentViewerWidget({required this.attachments, super.key});

  final List<RequestAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm.h,
      children: attachments.map((a) => _AttachmentItem(attachment: a)).toList(),
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  const _AttachmentItem({required this.attachment});

  final RequestAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final name = attachment.name ?? '';
    final iconPath = attachment.isPdf ? Assets.vectorsPdf : Assets.vectorsImage;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => AttachmentViewerScreen(attachment: attachment),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md.h,
          horizontal: AppSpacing.xl.w,
        ),
        decoration: BoxDecoration(
          color: context.colors.fileItemBackground,
          borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
          border: Border.all(color: context.colors.dividerColor),
        ),
        child: Row(
          children: [
            AppVectorGraphic(path: iconPath, width: 24.r, height: 24.r),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Text(
                name,
                style: context.typography.medium14,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20.r,
              color: context.colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
