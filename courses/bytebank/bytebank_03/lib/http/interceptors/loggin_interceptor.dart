import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print(' Request');
    print(data.toString());
    print(' Url: ${data.baseUrl}');
    print(' headers: ${data.headers}');
    print(' Body: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print(' Request');
    print(data.toString());
    print(' status code: ${data.statusCode}');
    print(' headers: ${data.headers}');
    print(' Body: ${data.body}');
    return data;
  }
}
