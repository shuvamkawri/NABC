// NABC 2026 — Dart-only static server + API proxy.
//
// Why this exists: the backend's lookups are GET requests that read their
// payload from the JSON *body*. Browsers cannot send a body on GET, and the
// API is plain http (mixed-content under HTTPS). This server lets the web app
// talk to a normal same-origin endpoint:
//
//   * Serves the compiled Flutter web app from build/web
//   * Proxies  POST /api/<name>  →  GET-with-body  http://45.79.175.205:3000/api-attendee/<name>
//   * Adds permissive CORS headers (so it also works cross-origin in dev)
//
// Run:
//   flutter build web --dart-define=API_BASE=/api
//   dart run bin/server.dart            # serves http://localhost:8080
//
// Env:  PORT (default 8080)

import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';
import 'package:http/http.dart' as http;

const _upstream = 'http://45.79.175.205:3000/api-attendee';

// The 3 attendee lookups: the live backend reads their payload from a GET body,
// so the proxy converts the browser's POST into a GET-with-body upstream call.
const _lookups = {'find-attendee', 'find-attendee-food', 'find-attendee-hotel'};

bool _isAllowed(String name) =>
    _lookups.contains(name) || name == 'events' || name.startsWith('chat/');

const _cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

Future<Response> _proxy(Request req, String name) async {
  if (!_isAllowed(name)) {
    return Response.notFound('Unknown API endpoint: $name');
  }
  final qs = req.url.query;
  final target = Uri.parse('$_upstream/$name${qs.isNotEmpty ? '?$qs' : ''}');
  try {
    http.Response res;
    if (_lookups.contains(name)) {
      // POST from the browser → GET-with-body upstream (live backend's format).
      final payload = await req.readAsString();
      final upstreamReq = http.Request('GET', target)
        ..headers['Content-Type'] = 'application/json'
        ..body = payload.isEmpty ? '{}' : payload;
      final streamed =
          await upstreamReq.send().timeout(const Duration(seconds: 20));
      res = await http.Response.fromStream(streamed);
    } else if (req.method == 'POST') {
      // events/chat POST → POST upstream (e.g. chat/send).
      final payload = await req.readAsString();
      res = await http
          .post(target,
              headers: {'Content-Type': 'application/json'}, body: payload)
          .timeout(const Duration(seconds: 20));
    } else {
      // GET upstream (events list, chat/list with query string).
      res = await http.get(target).timeout(const Duration(seconds: 20));
    }
    return Response(
      res.statusCode,
      body: res.body,
      headers: {'Content-Type': 'application/json', ..._cors},
    );
  } catch (e) {
    stderr.writeln('proxy error for $name: $e');
    return Response(
      502,
      body: '{"message":"upstream unreachable"}',
      headers: {'Content-Type': 'application/json', ..._cors},
    );
  }
}

void main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  const buildDir = 'build/web';

  final staticHandler = Directory(buildDir).existsSync()
      ? createStaticHandler(buildDir, defaultDocument: 'index.html')
      : (Request _) => Response.notFound(
          'build/web not found — run `flutter build web --dart-define=API_BASE=/api` first.');

  Future<Response> handler(Request req) async {
    if (req.method == 'OPTIONS') return Response.ok('', headers: _cors);
    final seg = req.url.pathSegments;
    if (seg.isNotEmpty && seg.first == 'api') {
      return _proxy(req, seg.skip(1).join('/'));
    }
    return staticHandler(req);
  }

  final pipeline =
      const Pipeline().addMiddleware(logRequests()).addHandler(handler);
  final server = await shelf_io.serve(pipeline, InternetAddress.anyIPv4, port);

  print('────────────────────────────────────────────────────────');
  print('NABC web server  →  http://localhost:${server.port}');
  print('API proxy        →  /api/*  ⇒  $_upstream/*');
  if (!Directory(buildDir).existsSync()) {
    print('⚠  $buildDir is missing. Build it first:');
    print('   flutter build web --dart-define=API_BASE=/api');
  }
  print('────────────────────────────────────────────────────────');
}