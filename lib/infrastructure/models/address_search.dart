class AddressSearch {
  final String displayName;
  final String formattedAddress;
  final double latitude;
  final double longitude;

  AddressSearch({
    required this.displayName,
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
  });

  factory AddressSearch.fromJson(Map<String, dynamic> json) {
    return AddressSearch(
      displayName: json['displayName'] ?? '',
      formattedAddress: json['formattedAddress'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'formattedAddress': formattedAddress,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
