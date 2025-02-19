class LaravelRestApiMutateBody {
  List<Mutation> mutate;

  LaravelRestApiMutateBody({
    required this.mutate,
  });

  factory LaravelRestApiMutateBody.fromJson(Map<String, dynamic> json) {
    return LaravelRestApiMutateBody(mutate: json["mutate"]);
  }

  Map<String, dynamic> toJson() {
    return {"mutate": mutate.map((m) => m.toJson()).toList()};
  }
}

class Mutation {
  MutationOperation operation;
  Map<String, dynamic>? attributes;
  dynamic key;

  Mutation({
    required this.operation,
    this.attributes,
    this.key,
  });

  factory Mutation.fromJson(Map<String, dynamic> json) {
    return Mutation(
      operation: MutationOperation.values.byName(json['operation']),
      attributes: json['attributes'],
      key: json['key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'operation': operation.name,
      if (attributes != null) 'attributes': attributes,
      if (key != null) 'key': key,
    };
  }
}

enum MutationOperation {
  create,
  update,
  attach,
  detach,
  toggle,
  sync,
}
