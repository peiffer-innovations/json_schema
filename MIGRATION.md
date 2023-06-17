# json_schema v3.x to v4 Migration Guide

json_schema 4.0 continues our journey to support additional new versions of the JSON Schema specification (Draft 2019-09 and Draft 2020-12)! In addition to the new draft support, we have better support for certain formats, as well as improved spec test compliance. 

There are several breaking removals, but there are replacements in 3.x that allow you to migrate safely (with the exception of `schemadot` and `refMap`, which have been deprecated for two majors). In order to account for these you should:

Stop using `schemadot`. As all the `schemadot` code has been deprecated for 2 major versions, and has remained unmaintained during that time, we have removed it. 

Stop using `JsonSchema.refMap`. It has been deprecated for two major versions and can change behaviorally between major versions. You should be able to use `JsonSchema.resolveRef` for these needs.

We have removed any need to configure the library for a specific environment, and all environment config now happens automatically. Therefore, you should:
- Replace all calls to:
   - `createSchemaFromUrlBrowser` with `JsonSchema.createFromUrl`
   - `createSchemaFromUrlVm` with `JsonSchema.createFromUrl`
- Remove all calls to:
  - `configureJsonSchemaForBrowser`
  - `configureJsonSchemaForVm`
  - `resetGlobalTransportPlatform`
- These changes can all be made on 3.x before migration.

We have simplified RefProviders. There are now fewer options, and the remaining options are easier to use. Migration to these should only cause code removal:
- Replace all calls to:
  -  `RefProvider.syncSchema` with `RefProvider.sync`
  -  `RefProvider.syncJson` with `RefProvider.sync`
  -  `RefProvider.asyncSchema` with `RefProvider.async`
  -  `RefProvider.asyncJson` with `RefProvider.async`
- These changes can all be made on 3.x before migration.

We have simplified factory names to be shorter.
- Replace all calls to:
  - `JsonSchema.createSchema` with `JsonSchema.create`
  - `JsonSchema.createSchemaAsync` with `JsonSchema.createAsync`
  - `JsonSchema.createSchemaFromUrl` with `JsonSchema.createFromUrl`
- These changes can all be made on 3.x before migration.

We have created one canonical method to get validation results.
- Replace all calls to:
  - `JsonSchema.validate` or `Validator.validate` with `validateWithResults(...).isValid` (3.2.0) and then `validate(...).isValid` (4.0) Default is now to return multiple errors instead of a single, configure to your liking.)
  - `JsonSchema.validateWithErrors` with `JsonSchema.validateWithResults(...).errors` (3.2.0) and then `JsonSchema.validate(...).errors` (4.0.0)
  - `Validator.errors` with `Validator.validateWithResults(...).errors` (3.2.0) and then `Validator.validate(...).errors` (4.0.0)
  - `Validator.errorObjects` with `Validator.validateWithResults(...).errors` (3.2.0) and then `Validator.validate(...).errors` (4.0.0)
- Migrate to `validateWithResults` in 3.2.0, then replace with breaking change to `validate` (returns the same payload as `validateWithResults`) in 4.x.

We have deprecated support for `DefaultValidators` and it's global getter / setter. The replacement is more full-featured and ergonomically similar our API for custom vocabularies.
- Replace `defaultValidators = <x>` with `JsonSchema.create(customFormats: {...})`

# json_schema v2.x to v3 Migration Guide

json_schema 3.0 is now here due to an issue that was found in 2.0 that caused remote refs to not get resolved correctly. This forced us to sort through the ref resolution logic in schema construction and change a few underlying assumptions.
- `JsonSchema.resolvePath` now takes a URI object as a parameter instead of a string.
- The `refProvider` parameter in the constructors is now a class you can configure to provide resolved `JsonSchema`s or valid JSON objects, synchronously or asynchronously.
  - 4 Static methods can be used for easy construction:
    - `RefProvider.syncSchema`
    - `RefProvider.syncJson`
    - `RefProvider.asyncSchema`
    - `RefProvider.asyncJson`
- The `_refMap` member used to contain references to all sub-schemas in the schema and remote refs, but now only contains remote referenced schemas and sub-schemas with unique `$id`s.
  - The public getter `refMap` is marked as deprecated due to the fact it shouldn't need to be used externally, but `resolvePath` should be used to fetch schemas from a given URI.
- Draft 7 is now supported and the default schema used!

We are now 100% spec compliant with all spec tests passing (a few optional tests are still skipped) with these new changes!


# json_schema v1.x to v2 Migration Guide

json_schema 2.0 is here, and is packed with useful updates! We've tried to minimize incompatibilities, while taking steps to build for the future. These include:

- json_schema is no longer bound to dart:io!
  - json_schema can now be used in either the browser or on a server by utilizing `configureJsonSchemaForBrowser()` or `configureBrowserForVm()`. Only necessary if you use async fetch of remote schemas via `createSchemaAsync`.
- JSON Schema draft6 compatibility
  - Allowing multiple spec versions (draft4 and draft6)
- Synchronous evaluation of schemas, by default.
  - Make fetching referenced schemas possible out-of-band and explicitly, while removing the default behavior to make HTTP calls.
- Renaming or splitting up certain keyword getters for better type-safety.
  - i.e. `bool additionalPropertiesBool` and `JsonSchema additionalPropertiesSchema` vs `dynamic addtionalProperties`.
- Automatic parsing of JSON strings when they are passed to `createSchema`, for more straightforward creation of schemas
- Optional parsing of JSON strings when they are passed to `validate`.
- The repo is now maintained by Workiva.


## Breaking Changes

- `Schema` --> `JsonSchema`
  - We've changed the name of the main class, for clarity.

- `JsonShema createSchema`
  - DON'T PANIC, we've changed the signature of the main constructor! We did this in order to allow syncronous evaluation of schemas by default.
  - There are a few paths you can take here:
    - If you were using `createSchema` to evaluate schemas that contained remote references you don't have cached locally, simply switch over to `createSchemaAsync`, which has the same behavior. If you continue to use the synchronous `createSchema`: *errors will be thrown when remote references are encountered*.
    - If you were using `createSchema` to evaluate schemas where all references can be resolved within the root schema, congrats! You can now remove all async behavior around creating schemas. No more async / await :)
    - If you were using `createSchema` to evaluate schema which have remote references, but you can cache all the remote references locally, you can use the optional `RefProvider` to allow sync resolution of those.
    - A new use case is also available: you can now use custom logic to resolve your own $refs using `RefProviderAsync` / `createSchemaAsync`.

- Platforms
  - dart:io Users: A single call to `configureBrowserForVm()` is required before using `createSchemaAsync`.
  - dart:html Users: A single call to `configureBrowserForBrowser()` is required before using `createSchemaAsync`.

- Removal of Custom Validation Logic
    - `set uriValidator` and `set emailValidator` have been removed and replaced with spec-supplied logical constraints.
    - This was removed because it was one-off for these two formats. Look for generic custom format validation in the future.

- `exclusiveMaximum` and `exclusiveMinimum`
  - changed `bool get exclusiveMinimum` --> `num get exclusiveMinimum` and
  `bool get exclusiveMaximum` --> `num get exclusiveMaximum`. The old boolean values are available under `bool get hasExclusiveMinimum` and `bool get hasExclusiveMaximum`, while the new values contain the actual value of the min / max. This is consistent with how the spec was changes, see the release notes: https://json-schema.org/draft-06/json-schema-release-notes.html

- `String get ref` --> `Uri get ref`
  - Since the spec specifies that $refs MUST be a URI, we've given refs some additional type safety.(https://tools.ietf.org/html/draft-wright-json-schema-01#section-8).

## Notable Deprecations

- `JsonSchema.refMap`
  - Note: This information is useful for drawing dependency graphs, etc, but should not be used for general 
validation or traversal. Use `endPath` to get the absolute `String` path and `resolvePath` to get the `JsonSchema` at any path, instead. This functionality will be removed in 3.0.

- All `schema_dot.dart` exports including `SchemaNode` and `createDot`
  - Unfortunetly, we don't have the resources to maintain this part of the codebase, as such, it has been untested against the major changes in 2.0, and is marked for future removal. Raise an issue or submit a PR if this was important to you.