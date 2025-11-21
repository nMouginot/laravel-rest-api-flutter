class LaravelRestApiMutateResponse {
  final List<dynamic> created;
  final List<dynamic> updated;

  LaravelRestApiMutateResponse({required this.created, required this.updated});

  factory LaravelRestApiMutateResponse.fromJson(Map<String, dynamic> json) {
    return LaravelRestApiMutateResponse(
      created: List<dynamic>.from(json['created'] ?? []),
      updated: List<dynamic>.from(json['updated'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'created': created, 'updated': updated};
  }
}
