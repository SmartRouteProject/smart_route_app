class ShareRouteResponse {
  final String sharedRouteId;
  final String shareLink;

  ShareRouteResponse({required this.sharedRouteId, required this.shareLink});

  factory ShareRouteResponse.fromJson(Map<String, dynamic> json) {
    return ShareRouteResponse(
      sharedRouteId: json['sharedRouteId'],
      shareLink: json['shareLink'],
    );
  }
}
