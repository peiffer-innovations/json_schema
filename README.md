# JSON Schema

**Temporary Fork**: This is a temporary fork to for [json_schema](https://github.com/Workiva/json_schema) to work with `0.2.0` of `rfc_6901`.  Once [this issue](https://github.com/Workiva/json_schema/issues/172) is resolved, this package will be discontinued.

  A *platform agnostic* (web, flutter or vm) Dart library for validating JSON instances against JSON Schemas (multi-version support with latest of Draft 7).

## Getting Started

1. Ensure you have latest stable Dart installed.
2. `make pubget`
3. `make format`
4. `make analyze`
5. `make test-with-serve-remotes`

### Alternative Test Running Strategy (To run specific tests, or pass other args to `dart test`):
1. `make serve-remotes` (in a separate terminal tab - HTTP fixtures need to be served for tests to pass)
2. `make test` or `dart test -n <YOUR TEST>` 
3. SIGINT your `make serve-remotes` tab or run `make stop-serve-remotes`

Note: For convenience, `make stop-serve-remotes` will be run as a prerequisite before `make test-with-serve-remotes` and `make serve-remotes`

### Updating Test Fixtures
1. `make gen-fixtures` Generates Dart source files that contain the JSON-Schema-Test-Suite tests and fixtures for use in cross-platform testing that doesn't require `dart:io` to read the files on disk.
2. Commit the results of generation, if any.

Note: CI runs `make gen-fixtures --check` to ensure these are up-to-date on each 

## Simple Example Usage

The simplest way to create a schema is to pass JSON data directly to `JsonSchema.create` with a JSON `String`, or decoded JSON via Dart `Map` or `bool`. 

After creating any schema, JSON instances can be validated by calling `.validate(instance)` on that schema. By default, instances are expected to be pre-parsed JSON as native dart primitives (`Map`, `List`, `String`, `bool`, `num`, `int`). You can also optionally parse at validation time by passing in a string and setting `parseJson`: `schema.validate('{ "name": "any JSON object"}', parseJson: true)`.

  > Note: Creating JsonSchemas synchronously implies access to all $refs within the root schema. If you don't have access to all this data at the time of the construction, see "Asynchronous Creation" examples below.

```dart
import 'package:json_schema/json_schema.dart';

main() {
  /// Define schema in a Dart [Map] or use a JSON [String].
  final mustBeIntegerSchemaMap = {"type": "integer"};

  // Create some examples to validate against the schema.
  final n = 3;
  final decimals = 3.14;
  final str = 'hi';

  // Construct the schema from the schema map or JSON string.
  final schema = JsonSchema.create(mustBeIntegerSchemaMap);

  print('$n => ${schema.validate(n)}'); // true
  print('$decimals => ${schema.validate(decimals)}'); // false
  print('$str => ${schema.validate(str)}'); // false
}
```

Or see [json_schema/example/readme/synchronous_creation/self_contained.dart](https://github.com/Workiva/json_schema/blob/master/example/readme/synchronous_creation/self_contained.dart)

And run `dart run ./example/readme/synchronous_creation/self_contained.dart`


## Advanced Usage

### Synchronous Creation, Local Ref Cache

If you want to create `JsonSchema`s synchronously, and you have $refs that cannot be resolved within the root schema, but you have a cache of those $ref'd schemas locally, you can write a `RefProvider` to get them during schema evaluation.

See [json_schema/example/readme/synchronous_creation/local_ref_cache.dart](https://github.com/Workiva/json_schema/blob/master/example/readme/synchronous_creation/local_ref_cache.dart)

Or run `dart run ./example/readme/synchronous_creation/local_ref_cache.dart`


### Asynchronous Creation, Remote HTTP Refs

If you have schemas that have nested $refs that are HTTP URIs that are publicly accessible, you can use `Future<JsonSchema> JsonSchema.createAsync` and the references will be fetched as needed during evaluation. You can also use `JsonSchema.createFromUrl` if you want to fetch the root schema remotely as well (see next example).

See [json_schema/example/readme/asynchronous_creation/remote_http_refs.dart](https://github.com/Workiva/json_schema/blob/master/example/readme/asynchronous_creation/remote_http_refs.dart)

Or run `dart run ./example/readme/asynchronous_creation/remote_http_refs.dart`

### Asynchronous Creation, From URL or File

You can also create a schema directly from a publicly accessible URL or File.

#### URLs
See [json_schema/example/readme/asynchronous_creation/from_url.dart](https://github.com/Workiva/json_schema/blob/master/example/readme/asynchronous_creation/from_url.dart)

Or run `dart run ./example/readme/asynchronous_creation/from_url.dart`

#### Files
See [json_schema/example/readme/asynchronous_creation/from_file.dart](https://github.com/Workiva/json_schema/blob/master/example/readme/asynchronous_creation/from_file.dart)

Or run `dart run ./example/readme/asynchronous_creation/from_file.dart`

### Asynchronous Creation, with custom remote $refs:

If you have nested $refs that are either non-HTTP URIs or non-publicly-accessible HTTP $refs, you can supply an async `RefProvider` to `createAsync`, and perform any custom logic you need.

See [json_schema/example/readme/asynchronous_creation/remote_ref_cache.dart](https://github.com/Workiva/json_schema/blob/master/example/readme/asynchronous_creation/remote_ref_cache.dart)

Or run `dart run ./example/readme/asynchronous_creation/remote_ref_cache.dart`

## How To Use Schema Information

  Schema information can be used for validation; but it can also be a valuable source of information about the structure of data. The `JsonSchema` class fully parses the schema first, which itself must be valid on all paths within the schema. Accessors are provided for all specified keywords of the JSON Schema specification associated with a schema, so tools can use it to create rich views of the data, like forms or diagrams.
