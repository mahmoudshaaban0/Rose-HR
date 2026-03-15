part of 'file_upload_cubit.dart';

/// Status for the overall file upload cubit
enum FileUploadStatus { initial, picking, encoding, uploading, success, error }

/// State for file upload cubit
class FileUploadState extends Equatable {
  const FileUploadState({
    this.status = FileUploadStatus.initial,
    this.files = const [],
    this.errorMessage,
    this.maxFiles = 10,
    this.maxFileSizeInMB = 10,
  });

  /// Overall status of the cubit
  final FileUploadStatus status;

  /// List of files being managed
  final List<UploadFileModel> files;

  /// General error message
  final String? errorMessage;

  /// Maximum number of files allowed
  final int maxFiles;

  /// Maximum file size in MB
  final int maxFileSizeInMB;

  /// Check if maximum files reached
  bool get isMaxFilesReached => files.length >= maxFiles;

  /// Check if there are any files
  bool get hasFiles => files.isNotEmpty;

  /// Check if all files are uploaded successfully
  bool get allFilesUploaded => files.isNotEmpty && files.every((file) => file.isUploadComplete);

  /// Check if any file is currently uploading
  bool get isAnyFileUploading => files.any((file) => file.isUploading);

  /// Get list of successfully uploaded files
  List<UploadFileModel> get uploadedFiles => files.where((file) => file.isUploadComplete).toList();

  /// Get list of files with errors
  List<UploadFileModel> get filesWithErrors => files.where((file) => file.hasError).toList();

  /// Get overall upload progress (0.0 to 1.0)
  double get overallProgress {
    if (files.isEmpty) return 0;
    final totalProgress = files.fold<double>(0, (sum, file) => sum + file.uploadProgress);
    return totalProgress / files.length;
  }

  @override
  List<Object?> get props => [
    status,
    files,
    errorMessage,
    maxFiles,
    maxFileSizeInMB,
  ];

  FileUploadState copyWith({
    FileUploadStatus? status,
    List<UploadFileModel>? files,
    String? errorMessage,
    int? maxFiles,
    int? maxFileSizeInMB,
    bool clearErrorMessage = false,
  }) {
    return FileUploadState(
      status: status ?? this.status,
      files: files ?? this.files,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      maxFiles: maxFiles ?? this.maxFiles,
      maxFileSizeInMB: maxFileSizeInMB ?? this.maxFileSizeInMB,
    );
  }
}
