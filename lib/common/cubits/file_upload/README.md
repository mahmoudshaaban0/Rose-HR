# File Upload Cubit - Usage Guide

## Overview
A reusable, clean-code BLoC/Cubit implementation for handling file uploads (images and PDFs) across the entire app.

## Features
- ✅ Pick multiple files (images or PDFs)
- ✅ Automatic base64 encoding
- ✅ Upload progress tracking per file
- ✅ File validation (size, type)
- ✅ Visual feedback with CircularProgressIndicator
- ✅ Appropriate icons (image/PDF) based on file type
- ✅ Clean architecture with separation of concerns
- ✅ Reusable across the entire app

## Architecture

```
lib/common/
├── cubits/
│   └── file_upload/
│       ├── file_upload_cubit.dart    # Business logic
│       ├── file_upload_state.dart    # State management
│       └── README.md                 # This file
├── models/
│   └── upload_file_model.dart        # File data model
└── widgets/
    └── file_upload_widget.dart       # Reusable UI widget
```

## Usage

### 1. Basic Usage in a Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/cubits/file_upload/file_upload_cubit.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/widgets/file_upload_widget.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  late final FileUploadCubit _fileUploadCubit;

  @override
  void initState() {
    super.initState();
    // Initialize the cubit with custom limits (optional)
    _fileUploadCubit = sl<FileUploadCubit>();
    // Or with custom parameters:
    // _fileUploadCubit = FileUploadCubit(maxFiles: 5, maxFileSizeInMB: 15);
  }

  @override
  void dispose() {
    _fileUploadCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Use the reusable widget
          FileUploadWidget(
            cubit: _fileUploadCubit,
            allowMultiple: true,
            fileType: FilePickerType.both, // or .image, .pdf
          ),
          
          // Submit button
          ElevatedButton(
            onPressed: () => _submitForm(),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    // Get uploaded files in API format
    final attachments = _fileUploadCubit.getAttachmentsForApi();
    
    // Use attachments in your API call
    // Example: createRequest(attachments: attachments);
  }
}
```

### 2. Using with BlocProvider

```dart
BlocProvider(
  create: (context) => sl<FileUploadCubit>(),
  child: Builder(
    builder: (context) {
      return FileUploadWidget(
        cubit: context.read<FileUploadCubit>(),
      );
    },
  ),
)
```

### 3. Customizing the Widget

```dart
FileUploadWidget(
  cubit: _fileUploadCubit,
  uploadAreaTitle: 'رفع المرفقات',
  uploadAreaSubtitle: 'PDF أو صورة (حد أقصى 10 ميجا)',
  allowMultiple: true,
  fileType: FilePickerType.both, // or .image, .pdf
  showUploadedFiles: true,
)
```

### 4. Listening to State Changes

```dart
BlocListener<FileUploadCubit, FileUploadState>(
  bloc: _fileUploadCubit,
  listener: (context, state) {
    if (state.status == FileUploadStatus.error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Error uploading files')),
      );
    }
    
    if (state.allFilesUploaded) {
      // All files uploaded successfully
      print('All files ready!');
    }
  },
  child: FileUploadWidget(cubit: _fileUploadCubit),
)
```

### 5. Manual File Picking

```dart
// Pick only images
await _fileUploadCubit.pickFiles(
  allowMultiple: true,
  fileType: FilePickerType.image,
);

// Pick only PDFs
await _fileUploadCubit.pickFiles(
  allowMultiple: false,
  fileType: FilePickerType.pdf,
);

// Pick both
await _fileUploadCubit.pickFiles(
  allowMultiple: true,
  fileType: FilePickerType.both,
);
```

### 6. Managing Files

```dart
// Remove a specific file
_fileUploadCubit.removeFile(fileId);

// Clear all files
_fileUploadCubit.clearAllFiles();

// Reset cubit to initial state
_fileUploadCubit.reset();

// Get attachments for API
final attachments = _fileUploadCubit.getAttachmentsForApi();
// Returns: List<Map<String, dynamic>> with keys: name, data, mimetype
```

### 7. Accessing State Properties

```dart
BlocBuilder<FileUploadCubit, FileUploadState>(
  bloc: _fileUploadCubit,
  builder: (context, state) {
    // Check various state properties
    final hasFiles = state.hasFiles;
    final isMaxReached = state.isMaxFilesReached;
    final allUploaded = state.allFilesUploaded;
    final isUploading = state.isAnyFileUploading;
    final progress = state.overallProgress; // 0.0 to 1.0
    
    // Get specific file lists
    final uploadedFiles = state.uploadedFiles;
    final filesWithErrors = state.filesWithErrors;
    
    return Text('Progress: ${(progress * 100).toInt()}%');
  },
)
```

## Integration with Existing API Models

The cubit provides `getAttachmentsForApi()` which returns data in the format expected by your API:

```dart
// Returns:
[
  {
    'name': 'document.pdf',
    'data': 'base64EncodedString...',
    'mimetype': 'application/pdf'
  },
  {
    'name': 'image.jpg',
    'data': 'base64EncodedString...',
    'mimetype': 'image/jpeg'
  }
]
```

This format matches the `AttachmentData` model used in `PermissionRequestRequestModel`:

```dart
final request = PermissionRequestRequestModel(
  // ... other fields
  attachmentIds: _fileUploadCubit.getAttachmentsForApi()
    .map((json) => AttachmentData.fromJson(json))
    .toList(),
);
```

## Configuration Options

### FileUploadCubit Parameters
- `maxFiles` (default: 10): Maximum number of files allowed
- `maxFileSizeInMB` (default: 10): Maximum file size in megabytes

### FilePickerType Options
- `FilePickerType.image`: Only allow images (jpg, jpeg, png, gif, webp, bmp)
- `FilePickerType.pdf`: Only allow PDF files
- `FilePickerType.both`: Allow both images and PDFs

## File Upload States

### FileUploadStatus
- `initial`: Initial state
- `picking`: User is selecting files
- `encoding`: Files are being encoded to base64
- `uploading`: Files are being uploaded
- `success`: All operations completed successfully
- `error`: An error occurred

### UploadStatus (per file)
- `idle`: File added but not yet processed
- `uploading`: File is being encoded/uploaded
- `success`: File successfully uploaded
- `error`: File upload failed

## Visual Feedback

The widget automatically shows:
- ✅ **CircularProgressIndicator** while uploading
- ✅ **Image icon** (`Assets.vectorsImage`) for images
- ✅ **PDF icon** (`Assets.vectorsPdf`) for PDFs
- ✅ **Success indicator** with checkmark when complete
- ✅ **Error message** if upload fails
- ✅ **File size** in human-readable format (B, KB, MB)
- ✅ **Delete button** to remove files

## Example: Punch Correction Screen Integration

```dart
class PunchCorrectionScreen extends StatefulWidget {
  const PunchCorrectionScreen({super.key});

  @override
  State<PunchCorrectionScreen> createState() => _PunchCorrectionScreenState();
}

class _PunchCorrectionScreenState extends State<PunchCorrectionScreen> {
  late final FileUploadCubit _fileUploadCubit;

  @override
  void initState() {
    super.initState();
    _fileUploadCubit = sl<FileUploadCubit>();
  }

  @override
  void dispose() {
    _fileUploadCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ... other form fields
          
          Text('Attachments', style: context.typography.medium16),
          FileUploadWidget(
            cubit: _fileUploadCubit,
            allowMultiple: true,
            fileType: FilePickerType.both,
          ),
          
          // Submit button
          PrimaryTextButton(
            onTap: () => _submitPunchCorrection(),
            label: 'Submit',
          ),
        ],
      ),
    );
  }

  void _submitPunchCorrection() {
    // Get attachments
    final attachments = _fileUploadCubit.getAttachmentsForApi();
    
    // Submit with attachments
    context.read<PunchCorrectionCubit>().submitPunchCorrection(
      // ... other parameters
      attachments: attachments,
    );
  }
}
```

## Best Practices

1. **Always dispose the cubit** when done to prevent memory leaks
2. **Use dependency injection** (`sl<FileUploadCubit>()`) for consistency
3. **Validate files** before submission using `state.allFilesUploaded`
4. **Handle errors** with BlocListener to show user feedback
5. **Clear files** after successful submission using `reset()`
6. **Set appropriate limits** based on your API requirements

## Troubleshooting

### Files not picking
- Ensure file_picker dependency is installed: `flutter pub get`
- Check platform-specific permissions (iOS: Info.plist, Android: AndroidManifest.xml)

### Large files causing issues
- Adjust `maxFileSizeInMB` parameter
- Consider implementing chunked upload for very large files

### Memory issues with many files
- Reduce `maxFiles` limit
- Clear files after submission using `reset()`

## Platform-Specific Setup

### iOS (Info.plist)
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to upload images</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take photos</string>
```

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

## Dependencies
- `file_picker: ^8.1.4` - For picking files from device
- `flutter_bloc: ^9.1.1` - For state management
- `equatable: ^2.0.7` - For value equality

