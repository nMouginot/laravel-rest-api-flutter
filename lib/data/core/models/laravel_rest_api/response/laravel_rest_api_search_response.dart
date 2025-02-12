class PaginatedResponse<T> {
  final int currentPage;
  final List<UserData> data;
  final int from;
  final int lastPage;
  final int perPage;
  final int to;
  final int total;
  final MetaData meta;

  PaginatedResponse({
    required this.currentPage,
    required this.data,
    required this.from,
    required this.lastPage,
    required this.perPage,
    required this.to,
    required this.total,
    required this.meta,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedResponse(
      currentPage: json['current_page'],
      data: (json['data'] as List<dynamic>)
          .map((item) => UserData.fromJson(item))
          .toList(),
      from: json['from'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      to: json['to'],
      total: json['total'],
      meta: MetaData.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((item) => item.toJson()).toList(),
      'from': from,
      'last_page': lastPage,
      'per_page': perPage,
      'to': to,
      'total': total,
      'meta': meta.toJson(),
    };
  }
}

class UserData {
  final int id;
  final String name;
  final Gates gates;

  UserData({required this.id, required this.name, required this.gates});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      gates: Gates.fromJson(json['gates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gates': gates.toJson(),
    };
  }
}

class Gates {
  final bool authorizedToView;
  final bool authorizedToUpdate;
  final bool authorizedToDelete;
  final bool authorizedToRestore;
  final bool authorizedToForceDelete;

  Gates({
    required this.authorizedToView,
    required this.authorizedToUpdate,
    required this.authorizedToDelete,
    required this.authorizedToRestore,
    required this.authorizedToForceDelete,
  });

  factory Gates.fromJson(Map<String, dynamic> json) {
    return Gates(
      authorizedToView: json['authorized_to_view'],
      authorizedToUpdate: json['authorized_to_update'],
      authorizedToDelete: json['authorized_to_delete'],
      authorizedToRestore: json['authorized_to_restore'],
      authorizedToForceDelete: json['authorized_to_force_delete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorized_to_view': authorizedToView,
      'authorized_to_update': authorizedToUpdate,
      'authorized_to_delete': authorizedToDelete,
      'authorized_to_restore': authorizedToRestore,
      'authorized_to_force_delete': authorizedToForceDelete,
    };
  }
}

class MetaData {
  final MetaGates gates;

  MetaData({required this.gates});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      gates: MetaGates.fromJson(json['gates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gates': gates.toJson(),
    };
  }
}

class MetaGates {
  final bool authorizedToCreate;

  MetaGates({required this.authorizedToCreate});

  factory MetaGates.fromJson(Map<String, dynamic> json) {
    return MetaGates(
      authorizedToCreate: json['authorized_to_create'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorized_to_create': authorizedToCreate,
    };
  }
}
