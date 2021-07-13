import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import 'interceptors/loggin_interceptor.dart';

final Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()], requestTimeout: Duration(seconds: 5));

final Uri baseUrl = Uri.http('192.168.68.109:8080', '/transactions');
