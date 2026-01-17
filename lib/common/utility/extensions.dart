// extenesion to check if string is null or empty
extension StringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

// extenesion to check if list is null or empty
extension ListExtension on List<dynamic>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

// extension to get AppLocalizations from BuildContext
