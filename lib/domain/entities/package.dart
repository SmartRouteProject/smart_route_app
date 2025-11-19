import 'dart:typed_data';

import 'package:smart_route_app/domain/domain.dart';

class Package {
  String description;
  PackageWeightType weight;
  Uint8List picture;

  Package({
    required this.description,
    required this.weight,
    required this.picture,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      description: json['description'] ?? '',
      weight: PackageWeightType.values.firstWhere(
        (e) => e.name == json['weight'],
        orElse: () => PackageWeightType.under25,
      ),
      picture: Uint8List.fromList(List<int>.from(json['picture'] ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'weight': weight.name,
      'picture': picture,
    };
  }
}
