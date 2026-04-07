import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/models/upload_file_model.dart';
import 'package:rose_hr/common/utility/logger.dart';

part 'file_upload_state.dart';

/// Cubit for managing file uploads (images and PDFs)
///
/// This cubit handles:
/// - Picking files from device
/// - Converting files to base64
/// - Tracking upload progress
/// - Managing multiple files
/// - Validation (file size, file type, max files)
class FileUploadCubit extends Cubit<FileUploadState> {
  FileUploadCubit({
    int maxFiles = 10,
    int maxFileSizeInMB = 10,
  }) : super(FileUploadState(maxFiles: maxFiles, maxFileSizeInMB: maxFileSizeInMB));

  /// Pick files from device (images or PDFs)
  ///
  /// [allowMultiple] - Whether to allow selecting multiple files
  /// [fileType] - Type of files to pick (image, pdf, or both)
  Future<void> pickFiles({
    bool allowMultiple = true,
    FilePickerType fileType = FilePickerType.both,
  }) async {
    if (isClosed) return;

    // Check if max files reached
    if (state.isMaxFilesReached && allowMultiple) {
      emit(
        state.copyWith(
          status: FileUploadStatus.error,
          errorMessage: 'Maximum ${state.maxFiles} files allowed',
        ),
      );
      return;
    }

    try {
      emit(state.copyWith(status: FileUploadStatus.picking, clearErrorMessage: true));

      // Configure file picker based on file type
      file_picker.FileType pickerFileType;
      List<String>? allowedExtensions;

      switch (fileType) {
        case FilePickerType.image:
          pickerFileType = file_picker.FileType.image;
        case FilePickerType.pdf:
          pickerFileType = file_picker.FileType.custom;
          allowedExtensions = ['pdf'];
        case FilePickerType.both:
          pickerFileType = file_picker.FileType.custom;
          allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
      }

      final result = await file_picker.FilePicker.platform.pickFiles(
        type: pickerFileType,
        allowMultiple: allowMultiple && !state.isMaxFilesReached,
        allowedExtensions: allowedExtensions,
      );

      if (result == null || result.files.isEmpty) {
        // User cancelled the picker
        emit(state.copyWith(status: FileUploadStatus.initial));
        return;
      }

      // Process picked files
      final newFiles = <UploadFileModel>[];
      final errors = <String>[];

      for (final platformFile in result.files) {
        // Check if max files reached
        if (state.files.length + newFiles.length >= state.maxFiles) {
          errors.add('Maximum ${state.maxFiles} files allowed');
          break;
        }

        // Validate file
        final validation = _validateFile(platformFile);
        if (validation != null) {
          errors.add(validation);
          continue;
        }

        // Create upload file model
        final uploadFile = UploadFileModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + platformFile.name.hashCode.toString(),
          name: platformFile.name,
          path: platformFile.path ?? '',
          fileType: FileType.fromExtension(platformFile.extension ?? ''),
          mimeType: _getMimeType(platformFile.extension ?? ''),
          size: platformFile.size,
        );

        newFiles.add(uploadFile);
      }

      // Add new files to state
      final updatedFiles = [...state.files, ...newFiles];
      emit(
        state.copyWith(
          status: FileUploadStatus.initial,
          files: updatedFiles,
          errorMessage: errors.isNotEmpty ? errors.first : null,
        ),
      );

      // Start encoding files to base64
      if (newFiles.isNotEmpty) {
        await _encodeFilesToBase64(newFiles);
      }
    } on Exception catch (e) {
      AppLogger.instance.logError('Error picking files: $e');
      emit(
        state.copyWith(
          status: FileUploadStatus.error,
          errorMessage: 'Failed to pick files: $e',
        ),
      );
    }
  }

  /// Validate a file
  String? _validateFile(file_picker.PlatformFile file) {
    // Check if file path exists
    if (file.path == null) {
      return 'File path is null';
    }

    // Check file size
    final fileSizeInMB = file.size / (1024 * 1024);
    if (fileSizeInMB > state.maxFileSizeInMB) {
      return '${file.name} exceeds ${state.maxFileSizeInMB}MB limit';
    }

    // Check file type
    final extension = file.extension?.toLowerCase();
    final allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
    if (extension == null || !allowedExtensions.contains(extension)) {
      return '${file.name} has unsupported file type';
    }

    return null;
  }

  /// Get MIME type from file extension
  String _getMimeType(String extension) {
    final ext = extension.toLowerCase();
    switch (ext) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      default:
        return 'application/octet-stream';
    }
  }

  /// Encode files to base64 using a background isolate to avoid UI jank.
  Future<void> _encodeFilesToBase64(List<UploadFileModel> filesToEncode) async {
    if (isClosed) return;

    emit(state.copyWith(status: FileUploadStatus.encoding));

    for (final file in filesToEncode) {
      try {
        _updateFileStatus(file.id, UploadStatus.uploading, progress: 0);

        final base64String = await compute(_readAndEncode, file.path);

        if (isClosed) return;

        _updateFile(
          file.id,
          file.copyWith(
            base64Data: base64String,
            uploadStatus: UploadStatus.success,
            uploadProgress: 1,
          ),
        );

        AppLogger.instance.logDebug('File encoded successfully: ${file.name}');
      } on Exception catch (e) {
        AppLogger.instance.logError('Error encoding file ${file.name}: $e');
        _updateFile(
          file.id,
          file.copyWith(
            uploadStatus: UploadStatus.error,
            errorMessage: 'Failed to encode file',
          ),
        );
      }
    }

    if (isClosed) return;
    emit(state.copyWith(status: FileUploadStatus.success));
  }

  /// Top-level function for isolate: reads file bytes and returns base64.
  static String _readAndEncode(String filePath) {
    final bytes = File(filePath).readAsBytesSync();
    return base64Encode(bytes);
  }

  /// Update file status and progress
  void _updateFileStatus(String fileId, UploadStatus status, {double? progress}) {
    if (isClosed) return;

    final updatedFiles = state.files.map((file) {
      if (file.id == fileId) {
        return file.copyWith(
          uploadStatus: status,
          uploadProgress: progress ?? file.uploadProgress,
        );
      }
      return file;
    }).toList();

    emit(state.copyWith(files: updatedFiles));
  }

  /// Update a specific file
  void _updateFile(String fileId, UploadFileModel updatedFile) {
    if (isClosed) return;

    final updatedFiles = state.files.map((file) {
      if (file.id == fileId) {
        return updatedFile;
      }
      return file;
    }).toList();

    emit(state.copyWith(files: updatedFiles));
  }

  /// Remove a file by ID
  void removeFile(String fileId) {
    if (isClosed) return;

    final updatedFiles = state.files.where((file) => file.id != fileId).toList();
    emit(
      state.copyWith(
        files: updatedFiles,
        status: FileUploadStatus.initial,
        clearErrorMessage: true,
      ),
    );

    AppLogger.instance.logDebug('File removed: $fileId');
  }

  /// Clear all files
  void clearAllFiles() {
    if (isClosed) return;

    emit(
      state.copyWith(
        files: [],
        status: FileUploadStatus.initial,
        clearErrorMessage: true,
      ),
    );

    AppLogger.instance.logDebug('All files cleared');
  }

  /// Get files in the format required by the API (AttachmentData)
  List<Map<String, dynamic>> getAttachmentsForApi() {
    return state.uploadedFiles.map((file) {
      return {
        'name': file.name,
        'data': file.base64Data ?? '',
        'mimetype': file.mimeType,
      };
    }).toList();
  }

  /// Reset cubit to initial state
  void reset() {
    if (isClosed) return;
    emit(FileUploadState(maxFiles: state.maxFiles, maxFileSizeInMB: state.maxFileSizeInMB));
  }
}

/// Enum for file picker type
enum FilePickerType { image, pdf, both }
