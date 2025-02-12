class LaravelRestApiSearchBody {
  final TextSearch? text;
  final List<Scope>? scopes;
  final List<Filter>? filters;
  final List<Sort>? sorts;
  final List<Select>? selects;
  final List<Include>? includes;
  final List<Aggregate>? aggregates;
  final List<Instruction>? instructions;
  final List<String>? gates;
  final int? page;
  final int? limit;

  LaravelRestApiSearchBody({
    this.text,
    this.scopes,
    this.filters,
    this.sorts,
    this.selects,
    this.includes,
    this.aggregates,
    this.instructions,
    this.gates,
    this.page,
    this.limit,
  });

  factory LaravelRestApiSearchBody.fromJson(Map<String, dynamic> json) {
    return LaravelRestApiSearchBody(
      text: json['text'] != null ? TextSearch.fromJson(json['text']) : null,
      scopes: (json['scopes'] as List<dynamic>?)
          ?.map((e) => Scope.fromJson(e))
          .toList(),
      filters: (json['filters'] as List<dynamic>?)
          ?.map((e) => Filter.fromJson(e))
          .toList(),
      sorts: (json['sorts'] as List<dynamic>?)
          ?.map((e) => Sort.fromJson(e))
          .toList(),
      selects: (json['selects'] as List<dynamic>?)
          ?.map((e) => Select.fromJson(e))
          .toList(),
      includes: (json['includes'] as List<dynamic>?)
          ?.map((e) => Include.fromJson(e))
          .toList(),
      aggregates: (json['aggregates'] as List<dynamic>?)
          ?.map((e) => Aggregate.fromJson(e))
          .toList(),
      instructions: (json['instructions'] as List<dynamic>?)
          ?.map((e) => Instruction.fromJson(e))
          .toList(),
      gates:
          (json['gates'] as List<dynamic>?)?.map((e) => e as String).toList(),
      page: json['page'] as int?,
      limit: json['limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (text != null) 'text': text!.toJson(),
      if (scopes != null) 'scopes': scopes!.map((e) => e.toJson()).toList(),
      if (filters != null) 'filters': filters!.map((e) => e.toJson()).toList(),
      if (sorts != null) 'sorts': sorts!.map((e) => e.toJson()).toList(),
      if (selects != null) 'selects': selects!.map((e) => e.toJson()).toList(),
      if (includes != null)
        'includes': includes!.map((e) => e.toJson()).toList(),
      if (aggregates != null)
        'aggregates': aggregates!.map((e) => e.toJson()).toList(),
      if (instructions != null)
        'instructions': instructions!.map((e) => e.toJson()).toList(),
      if (gates != null) 'gates': gates,
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };
  }
}

class TextSearch {
  final String? value;

  TextSearch({this.value});

  factory TextSearch.fromJson(Map<String, dynamic> json) {
    return TextSearch(value: json['value'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      if (value != null) 'value': value,
    };
  }
}

class Scope {
  final String name;
  final List<dynamic>? parameters;

  Scope({required this.name, this.parameters});

  factory Scope.fromJson(Map<String, dynamic> json) {
    return Scope(
      name: json['name'] as String,
      parameters: json['parameters'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (parameters != null) 'parameters': parameters,
    };
  }
}

class Filter {
  final String? field;
  final String? operator;
  final dynamic value;
  final String? type;
  final List<Filter>? nested;

  Filter({this.field, this.operator, this.value, this.type, this.nested});

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      field: json['field'] as String?,
      operator: json['operator'] as String?,
      value: json['value'],
      type: json['type'] as String?,
      nested: (json['nested'] as List<dynamic>?)
          ?.map((e) => Filter.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (field != null) 'field': field,
      if (operator != null) 'operator': operator,
      if (value != null) 'value': value,
      if (type != null) 'type': type,
      if (nested != null) 'nested': nested!.map((e) => e.toJson()).toList(),
    };
  }
}

class Sort {
  final String field;
  final String direction;

  Sort({required this.field, required this.direction});

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      field: json['field'] as String,
      direction: json['direction'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'direction': direction,
    };
  }
}

class Select {
  final String field;

  Select({required this.field});

  factory Select.fromJson(Map<String, dynamic> json) {
    return Select(
      field: json['field'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
    };
  }
}

class Include {
  final String relation;
  final List<Filter>? filters;
  final int? limit;

  Include({required this.relation, this.filters, this.limit});

  factory Include.fromJson(Map<String, dynamic> json) {
    return Include(
      relation: json['relation'] as String,
      filters: (json['filters'] as List<dynamic>?)
          ?.map((e) => Filter.fromJson(e))
          .toList(),
      limit: json['limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'relation': relation,
      if (filters != null) 'filters': filters!.map((e) => e.toJson()).toList(),
      if (limit != null) 'limit': limit,
    };
  }
}

class Aggregate {
  final String relation;
  final String type;
  final String field;
  final List<Filter>? filters;

  Aggregate({
    required this.relation,
    required this.type,
    required this.field,
    this.filters,
  });

  factory Aggregate.fromJson(Map<String, dynamic> json) {
    return Aggregate(
      relation: json['relation'] as String,
      type: json['type'] as String,
      field: json['field'] as String,
      filters: (json['filters'] as List<dynamic>?)
          ?.map((e) => Filter.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'relation': relation,
      'type': type,
      'field': field,
      if (filters != null) 'filters': filters!.map((e) => e.toJson()).toList(),
    };
  }
}

class Instruction {
  final String name;
  final List<Field> fields;

  Instruction({required this.name, required this.fields});

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      name: json['name'] as String,
      fields: (json['fields'] as List<dynamic>)
          .map((e) => Field.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fields': fields.map((e) => e.toJson()).toList(),
    };
  }
}

class Field {
  final String name;
  final dynamic value;

  Field({required this.name, required this.value});

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      name: json['name'] as String,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}
