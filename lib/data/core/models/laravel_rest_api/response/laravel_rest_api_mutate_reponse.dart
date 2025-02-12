class LaravelRestApiMutateResponse {
  final List<int> created;
  final List<int> updated;

  LaravelRestApiMutateResponse({
    required this.created,
    required this.updated,
  });

  factory LaravelRestApiMutateResponse.fromJson(Map<String, dynamic> json) {
    return LaravelRestApiMutateResponse(
      created: List<int>.from(json['created'] ?? []),
      updated: List<int>.from(json['updated'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created': created,
      'updated': updated,
    };
  }
}
