enum PackageWeightType {
  under25,
  over25;

  static PackageWeightType fromString(String value) {
    return PackageWeightType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PackageWeightType.under25,
    );
  }
}

extension PackageWeightTypeExt on PackageWeightType {
  String getStringValue() => name;

  String get label {
    switch (this) {
      case PackageWeightType.under25:
        return 'Menos de 25kg';
      case PackageWeightType.over25:
        return 'Mas de 25kg';
    }
  }
}
