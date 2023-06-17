import 'package:json_schema/src/json_schema/schema_url_client/schema_url_client.dart';

/// Implemented in `html_schema_url_client.dart` and `io_schema_url_client.dart`.
SchemaUrlClient createClient() => throw UnsupportedError('Cannot create a client without dart:html or dart:io.');
