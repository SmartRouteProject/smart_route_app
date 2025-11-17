class ReturnAddress {
  String nickname;
  double latitude;
  double longitude;
  String address;

  ReturnAddress({
    required this.nickname,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory ReturnAddress.fromJson(Map<String, dynamic> json) {
    return ReturnAddress(
      nickname: json['nickname'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}
