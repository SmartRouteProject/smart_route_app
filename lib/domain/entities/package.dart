import 'dart:convert';
import 'dart:io';

import 'package:smart_route_app/domain/domain.dart';

class Package {
  String description;
  PackageWeightType weight;
  File? picture;

  Package({required this.description, required this.weight, this.picture});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      description: json['description'] ?? '',
      weight: PackageWeightType.values.firstWhere(
        (e) => e.name == json['weight'],
        orElse: () => PackageWeightType.under_25kg,
      ),
      picture: _fileFromBase64(json['picture']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'weight': weight.name,
      'picture': _fileToBase64(),
    };
  }

  static File? _fileFromBase64(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    try {
      final bytes = base64Decode(value);
      final fileName = 'package_${DateTime.now().microsecondsSinceEpoch}.png';
      final file = File('${Directory.systemTemp.path}/$fileName');
      file.writeAsBytesSync(bytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  String _fileToBase64() {
    try {
      if (picture == null) return '';
      final bytes = picture!.readAsBytesSync();
      return base64Encode(bytes);
    } catch (_) {
      return '';
    }
  }
}
