class LaravelRestApiActionsBody {
  final List<Action> fields;

  LaravelRestApiActionsBody({required this.fields});

  factory LaravelRestApiActionsBody.fromJson(Map<String, dynamic> json) {
    return LaravelRestApiActionsBody(
      fields:
          (json['fields'] as List<dynamic>)
              .map((e) => Action.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'fields': fields.map((action) => action.toJson()).toList()};
  }
}

class Action {
  final String name;
  final String value;

  Action({required this.name, required this.value});

  factory Action.fromJson(Map<String, dynamic> json) {
    return Action(name: json['name'] as String, value: json['value'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}
