import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

class MockClient extends BaseClient {
  static final _jsonUtf8 = json.fuse(utf8);

  final Object? Function(String method, Object? payload) handler;

  MockClient(this.handler);

  Response _buildResponse(String body, Map<String, dynamic> data, int status) {
    final id = data['id'];
    final method = data['method'] as String;
    final params = data['params'];
    final response = {
      'body': body,
      'id': id,
      'result': handler(method, params)
    };

    return Response(json.encode(response), status);
  }

  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    if (body is! String) {
      fail('Invalid request, expected string as request body');
    }

    final data = json.decode(body) as Map<String, dynamic>;
    if (data['jsonrpc'] != '2.0') {
      fail('Expected request to contain correct jsonrpc key');
    }

    final String u = url.toString();
    if (u.endsWith("/SocketException")) {
      throw SocketException("generated socket error for $url");
    } else {
      final RegExp regex = RegExp(r"^.*\/HttpStatus\/([0-9]+)");
      final match = regex.firstMatch(u);
      if (match != null) {
        String code = match.group(1) ?? "";
        return Response("HTTP status $code", int.parse(code));
      }
    }

    
    return _buildResponse(body, data, 200);
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final data = await _jsonUtf8.decoder.bind(request.finalize()).first;

    if (data is! Map) {
      fail('Invalid request, expected JSON map');
    }

    if (data['jsonrpc'] != '2.0') {
      fail('Expected request to contain correct jsonrpc key');
    }

    final id = data['id'];
    final method = data['method'] as String;
    final params = data['params'];

    final response = Result(() => handler(method, params));

    return StreamedResponse(
      _jsonUtf8.encoder.bind(
        Stream.value(
          {
            'jsonrpc': '2.0',
            if (response is ValueResult) 'result': response.value,
            if (response is ErrorResult)
              'error': {
                'code': -1,
                'message': '${response.error}',
              },
            'id': id,
          },
        ),
      ),
      200,
    );
  }
}
