class LaravelRestApiMutateBody {
  List<Mutation> mutate;

  LaravelRestApiMutateBody({required this.mutate});

  Map<String, dynamic> toJson() {
    return {"mutate": mutate.map((m) => m.toJson()).toList()};
  }
}

class Mutation {
  bool? withoutDetaching;
  List<MutationRelation>? relations;
  MutationOperation operation;
  Map<String, dynamic>? attributes;
  dynamic key;

  Mutation({
    this.key,
    this.relations,
    this.attributes,
    this.withoutDetaching,

    required this.operation,
  });

  Map<String, dynamic> toJson() {
    return {
      'operation': operation.name,
      if (key != null) 'key': key,
      if (withoutDetaching != null) 'without_detaching': withoutDetaching,
      if (attributes != null) 'attributes': attributes,
      if (relations?.isNotEmpty == true)
        'relations': {
          for (final relation in relations!)
            relation.table:
                relation.relationType == RelationType.singleRelation
                    ? relation.toJson()
                    : [relation.toJson()],
        },
    };
  }
}

enum MutationOperation { create, update }

/// Determines the **serialization format** of the relation in the API request.
///
/// - **`singleRelation`**:
///   Used for 1:1 relationships (e.g., `belongsTo`, `hasOne`).
///   → Generates a Map in JSON (e.g., `"star": { "operation": "detach", "key": 1 }`).
///   Typical case: Only one operation possible (e.g., detaching a single related model).
///
/// - **`multipleRelation`**:
///   Used for 1:N or N:N relationships (e.g., `hasMany`, `belongsToMany`).
///   → Generates an Array of Maps (e.g., `"posts": [{ "operation": "sync", "key": 1 }]`).
///   Typical case: Multiple operations on related models (e.g., syncing a list of posts).
///
/// **Choosing Rule**:
/// Matches the **Eloquent relationship type** in Laravel.
/// See [Laravel Eloquent Relationships](https://laravel.com/docs/10.x/eloquent-relationships).
enum RelationType { singleRelation, multipleRelation }

enum MutationRelationOperation { create, update, attach, detach, toggle, sync }

class MutationRelation {
  dynamic key;
  String table;
  bool? withoutDetaching;
  RelationType relationType;
  Map<String, dynamic>? pivot;
  Map<String, dynamic>? attributes;
  List<MutationRelation>? relations;
  MutationRelationOperation operation;

  MutationRelation({
    this.key,
    this.pivot,
    this.relations,
    this.attributes,
    this.withoutDetaching,
    this.relationType = RelationType.singleRelation,

    required this.table,
    required this.operation,
  });

  Map<String, dynamic> toJson() {
    return {
      'operation': operation.name,
      if (key != null) 'key': key,
      if (pivot != null) 'pivot': pivot,
      if (relations != null) 'relations': relations,
      if (attributes != null) 'attributes': attributes,
      if (withoutDetaching != null) 'without_detaching': withoutDetaching,
    };
  }
}
