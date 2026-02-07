enum RouteState {
  planned,
  started,
  completed;

  static RouteState fromString(String value) {
    return RouteState.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => RouteState.planned,
    );
  }
}

extension RouteStateExt on RouteState {
  String getStringValue() => name;

  String get label {
    switch (this) {
      case RouteState.planned:
        return 'Planeada';
      case RouteState.started:
        return 'Iniciada';
      case RouteState.completed:
        return 'Completada';
    }
  }
}
