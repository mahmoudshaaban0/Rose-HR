import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/features/requests/data/models/single_request_response_by_id.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AttachmentViewerScreen extends StatelessWidget {
  const AttachmentViewerScreen({required this.attachment, super.key});

  final RequestAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final url = attachment.url ?? '';
    final title = attachment.name ?? '';

    return Scaffold(
      appBar: PrimaryAppBar(title: title),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: attachment.isPdf ? _PdfView(url: url) : _ImageView(url: url),
      ),
    );
  }
}

class _PdfView extends StatelessWidget {
  const _PdfView({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder(context);
    return SfPdfViewer.network(url);
  }

  Widget _placeholder(BuildContext context) {
    return Center(
      child: Text(
        'No URL available',
        style: context.typography.regular14,
      ),
    );
  }
}

class _ImageView extends StatelessWidget {
  const _ImageView({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Center(
        child: Text('No URL available', style: context.typography.regular14),
      );
    }
    return PhotoView(
      imageProvider: NetworkImage(url),
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 4,
      backgroundDecoration: const BoxDecoration(color: Colors.black),
      loadingBuilder: (_, _) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      errorBuilder: (_, _, _) => Center(
        child: Text(
          'Failed to load image',
          style: context.typography.regular14.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
