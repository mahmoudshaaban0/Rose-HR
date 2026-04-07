import 'package:equatable/equatable.dart';

/// Enum for file types
enum FileType {
  image,
  pdf,
  unknown;

  /// Get file type from mime type
  static FileType fromMimeType(String mimeType) {
    if (mimeType.startsWith('image/')) {
      return FileType.image;
    } else if (mimeType == 'application/pdf') {
      return FileType.pdf;
    }
    return FileType.unknown;
  }

  /// Get file type from file extension
  static FileType fromExtension(String extension) {
    final ext = extension.toLowerCase().replaceAll('.', '');
    switch (ext) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
      case 'bmp':
        return FileType.image;
      case 'pdf':
        return FileType.pdf;
      default:
        return FileType.unknown;
    }
  }
}

/// Enum for upload status of individual files
enum UploadStatus { idle, uploading, success, error }

/// Model representing a single file to be uploaded
class UploadFileModel extends Equatable {
  const UploadFileModel({
    required this.id,
    required this.name,
    required this.path,
    required this.fileType,
    required this.mimeType,
    this.size = 0,
    this.base64Data,
    this.uploadStatus = UploadStatus.idle,
    this.uploadProgress = 0.0,
    this.errorMessage,
  });

  /// Unique identifier for the file
  final String id;

  /// File name
  final String name;

  /// Local file path
  final String path;

  /// Type of file (image or pdf)
  final FileType fileType;

  /// MIME type
  final String mimeType;

  /// File size in bytes
  final int size;

  /// Base64 encoded data (populated after encoding)
  final String? base64Data;

  /// Upload status
  final UploadStatus uploadStatus;

  /// Upload progress (0.0 to 1.0)
  final double uploadProgress;

  /// Error message if upload failed
  final String? errorMessage;

  /// Get formatted file size
  String get formattedSize {
    if (size < 1024) {
      return 'B $size';
    } else if (size < 1024 * 1024) {
      return 'KB ${(size / 1024).toStringAsFixed(1)}';
    } else {
      return 'MB ${(size / (1024 * 1024)).toStringAsFixed(1)}';
    }
  }

  /// Check if file is an image
  bool get isImage => fileType == FileType.image;

  /// Check if file is a PDF
  bool get isPdf => fileType == FileType.pdf;

  /// Check if file is uploading
  bool get isUploading => uploadStatus == UploadStatus.uploading;

  /// Check if file upload is complete
  bool get isUploadComplete => uploadStatus == UploadStatus.success;

  /// Check if file upload failed
  bool get hasError => uploadStatus == UploadStatus.error;

  @override
  List<Object?> get props => [
    id,
    name,
    path,
    fileType,
    mimeType,
    size,
    base64Data != null,
    uploadStatus,
    uploadProgress,
    errorMessage,
  ];

  UploadFileModel copyWith({
    String? id,
    String? name,
    String? path,
    FileType? fileType,
    String? mimeType,
    int? size,
    String? base64Data,
    UploadStatus? uploadStatus,
    double? uploadProgress,
    String? errorMessage,
    bool clearBase64Data = false,
    bool clearErrorMessage = false,
  }) {
    return UploadFileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      fileType: fileType ?? this.fileType,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
      base64Data: clearBase64Data ? null : (base64Data ?? this.base64Data),
      uploadStatus: uploadStatus ?? this.uploadStatus,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
