
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/loggin_interceptor.dart';



final Client client =
    HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);

final Uri baseUrl = Uri.http('192.168.68.105:8080', '/transactions');

