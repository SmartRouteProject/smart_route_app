enum StopStatus {
  pending,
  failed,
  succeeded;

  static StopStatus fromString(String value) {
    return StopStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => StopStatus.pending,
    );
  }
}

extension StopStatusExt on StopStatus {
  String getStringValue() => name;

  String get label {
    switch (this) {
      case StopStatus.pending:
        return 'Pendiente';
      case StopStatus.failed:
        return 'Fallido';
      case StopStatus.succeeded:
        return 'Exitoso';
    }
  }
}
