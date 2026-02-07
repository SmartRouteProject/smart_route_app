enum PackageWeightType {
  under_25kg,
  over_25kg;

  static PackageWeightType fromString(String value) {
    return PackageWeightType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PackageWeightType.under_25kg,
    );
  }
}

extension PackageWeightTypeExt on PackageWeightType {
  String getStringValue() => name;

  String get label {
    switch (this) {
      case PackageWeightType.under_25kg:
        return 'Menos de 25kg';
      case PackageWeightType.over_25kg:
        return 'Mas de 25kg';
    }
  }
}
