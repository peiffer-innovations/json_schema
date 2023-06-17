import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

import 'cors_headers.dart';

main() {
  // Serve remotes for ref tests.
  final specFileHandler = createStaticHandler('test/JSON-Schema-Test-Suite/remotes');
  var specFileHandlerWithCors = const Pipeline().addMiddleware(corsHeaders()).addHandler(specFileHandler);
  io.serve(specFileHandlerWithCors, 'localhost', 1234);

  final additionalRemotesHandler = createStaticHandler('test/additional_remotes');
  var additionalRemotesHandlerWithCors =
      const Pipeline().addMiddleware(corsHeaders()).addHandler(additionalRemotesHandler);
  io.serve(additionalRemotesHandlerWithCors, 'localhost', 4321);
}
