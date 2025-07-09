# 📦 Laravel REST API - Flutter Integration

This guide explains how to use the **laravel_rest_api** package to interact with a Laravel REST API within a Flutter application. It covers implementing a custom **HttpClient** and several operations: **search**, **delete**, **mutate**, and **actions**.

https://laravel-rest-api.lomkit.com/getting-started/installation
---

## 📌 Installation

Add **laravel_rest_api_flutter** to your `pubspec.yaml`:

```yaml
dependencies:
  laravel_rest_api_flutter: latest_version
  dio: ^5.0.0 # your http package
```

Then run:

```sh
flutter pub get
```

---

## 🚀 Setup

### 1️⃣ Create a Custom API Client

Here is an example of a custom **HttpClient** using `Dio`:

```dart
class ApiHttpClient implements RestApiClient {
  final Dio dio;

  ApiHttpClient({required this.dio});

  @override
  Future<RestApiResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final response = await dio.get(
        "${dio.options.baseUrl}$url",
        options: Options(headers: headers),
        queryParameters: queryParams,
      );
      return RestApiResponse(
        statusCode: response.statusCode,
        body: response.data,
      );
    } catch (exception, stackTrace) {
      return handleError(exception, stackTrace);
    }
  }

  @override
  Future<RestApiResponse> post(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    Object? body,
  }) async {
    try {
      final response = await dio.post(
        "${dio.options.baseUrl}$url",
        options: Options(headers: headers),
        queryParameters: queryParams,
        data: body,
      );
      return RestApiResponse(
        statusCode: response.statusCode,
        body: response.data,
        message: response.statusMessage,
      );
    } catch (exception, stackTrace) {
      return handleError(exception, stackTrace);
    }
  }

  @override
  Future<RestApiResponse> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    Object? body,
  }) async {
    try {
      final response = await dio.delete(
        "${dio.options.baseUrl}$url",
        options: Options(headers: headers),
        queryParameters: queryParams,
        data: body,
      );
      return RestApiResponse(
        statusCode: response.statusCode,
        body: response.data,
      );
    } catch (exception, stackTrace) {
      return handleError(exception, stackTrace);
    }
  }

  @override
  RestApiResponse handleError(dynamic exception, StackTrace stackTrace) {
    if (exception is DioException) {
      return RestApiResponse(
        statusCode: exception.response?.statusCode,
        body: exception.response?.data ?? {'error': exception.message},
      );
    }
    return RestApiResponse(
      statusCode: 500,
      body: {'error': exception},
    );
  }
}
```

---

### 2️⃣ Define a Model

Example `ItemModel`:

```dart
class ItemModel {
  final int id;
  final String name;

  ItemModel({required this.id, required this.name});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
```

---

### 3️⃣ Create a Repository

A repository can combine multiple mixins such as `SearchFactory`, `DeleteFactory`, `MutateFactory`, and `ActionsFactory`:

```dart
class ItemRepository with SearchFactory<ItemModel>,
    DeleteFactory<ItemModel>, MutateFactory<ItemModel>, ActionsFactory<ItemModel> {

  @override
  String get baseRoute => '/items';

  @override
  ItemModel fromJson(Map<String, dynamic> json) => ItemModel.fromJson(json);
}
```

---

## 🔍 Usage

### 🔹 Searching (Search)

You can search data by providing various parameters (`filters`, `sorts`, `includes`, etc.):

```dart
final repository = ItemRepository();

void fetchItems() async {
  final response = await repository.search(filters: [
    Filter(field: "name", type: "contains", value: "Test")
  ]);
  if (response.isSuccessful) {
    print(response.body); // Filtered items
  } else {
    print('Error: ${response.statusCode}');
  }
}
```

### 🔹 Mutations (Create / Update)

Use `mutate` to create or update items:

```dart
final newItem = ItemModel(id: 3, name: "New Item");
await repository.mutate(
  body: LaravelRestApiMutateBody(
    mutate: [
      // Create an item
      Mutation(
        operation: MutationOperation.create,
        attributes: newItem.toJson(),
      ),
      // Update an item
      Mutation(
        operation: MutationOperation.update,
        key: 3,
        attributes: {"name": "Updated Name"},
      ),
    ],
  ),
);
```

### 🔹 Deleting (Delete)

Delete one or more items:

```dart
//resourceIds is list of IDs or UUIDs representing the resources to delete.
await repository.delete(resourceIds: [5, 6]);
```

### 🔹 Custom Actions

Use `actions` to perform custom business logic defined in Laravel (e.g., `activate`):

```dart
await repository.actions(
  data: LaravelRestApiActionsBody(
    fields: [
      Action(name: "expires_at", value: "2023-04-29"),
    ],
  ),
);
```

---

## 🔹 Request Parameters and Responses

### Search
- **Filters**: Filter by a field and condition.
- **Sort**: Sort results (e.g., {"name": "asc"}).
- **Selects**: Select specific fields.
- **Includes**: Load relationships.
- **Aggregates**: Aggregation functions (`count`, `sum`, etc.).
- **Pagination**: `page`, `limit`, etc.

### Delete
- **resourceIds**: List of IDs or UUIDs representing the resources to delete.

Response:
- `data` may contain the list of deleted items.

### Mutate
- **mutate**: A list of operations (create, update, etc.).

Response:
- `{"created": [], "updated": []}` to track impacted IDs.

### Actions
- **fields**: e.g. `[{"name": "expires_at", "value": "2023-04-29"}]`.

Response:
- `{"data": {"impacted": 10}}` if 10 records were affected.

---

### Example Response

API responses typically follow this structure:

```json
{
  "data": [
    {"id": 1, "name": "Lou West"},
    {"id": 2, "name": "Bridget Wilderman"}
  ],
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "total": 50
  }
}
```

Or, for certain actions:

```json
{
  "message": "Server error",
  "exception": "Symfony\\Component\\HttpKernel\\Exception\\NotFoundHttpException"
}
```

## Examples & Integration tests

```dart
test('Search items by name filter', () async {
  final itemRepository = ItemRepository();
  final result = await itemRepository.search(filters: [
    Filter(field: 'name', type: 'contains', value: 'Hammer'),
  ]);

  expect(result.statusCode, 200);
  expect(result.data, isNotNull, reason: result.message);
});

// Deleting items

test('Delete items by IDs', () async {
  final itemRepository = ItemRepository();
  final result = await itemRepository.delete(resourceIds: [5, 6]);

  expect(result.statusCode, 200);
  expect(result.data, isNotNull, reason: result.message);
});

// Mutating (create/update)

test('Create a new item via mutate', () async {
  final itemRepository = ItemRepository();
  final newItem = ItemModel(id: 10, name: 'New Test Item');

  final result = await itemRepository.mutate(
    body: LaravelRestApiMutateBody(
      mutate: [
        Mutation(
          operation: MutationOperation.create,
          attributes: newItem.toJson(),
        ),
      ],
    ),
  );

  expect(result.statusCode, 200);
  expect(result.data?.created.contains(10), true);
});

test('Update an existing item via mutate', () async {
  final itemRepository = ItemRepository();

  final result = await itemRepository.mutate(
    body: LaravelRestApiMutateBody(
      mutate: [
        Mutation(
          operation: MutationOperation.update,
          key: 10,
          attributes: {'name': 'Updated Test Item'},
        ),
      ],
    ),
  );

  expect(result.statusCode, 200);
  expect(result.data?.updated.contains(10), true);
});

// Custom actions

test('Perform a custom action on items', () async {
  final itemRepository = ItemRepository();
  final result = await itemRepository.actions(
    data: LaravelRestApiActionsBody(
      fields: [
        Action(name: 'activate', value: 'true'),
      ],
    ),
  );

  expect(result.statusCode, 200);
  expect(result.data, greaterThanOrEqualTo(1));
});
```