class LaravelRestApiMutateBody {
  List<Mutation> mutate;

  LaravelRestApiMutateBody({required this.mutate});

  Map<String, dynamic> toJson() {
    return {"mutate": mutate.map((m) => m.toJson()).toList()};
  }
}

class Mutation {
  MutationOperation operation;
  Map<String, dynamic>? attributes;
  dynamic key;

  Mutation({required this.operation, this.attributes, this.key});

  Map<String, dynamic> toJson() {
    return {
      'operation': operation.name,
      if (attributes != null) 'attributes': attributes,
      if (key != null) 'key': key,
    };
  }
}

enum MutationOperation { create, update, attach, detach, toggle, sync }
