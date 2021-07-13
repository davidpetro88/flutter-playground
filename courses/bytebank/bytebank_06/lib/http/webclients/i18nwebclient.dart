import 'dart:convert';

import 'package:http/http.dart';

import '../webclient.dart';

const MESSSAGES_URI = "gist.githubusercontent.com";
const MESSSAGES_URI_PATH = "/davidpetro88/f988fa8bd82cc8e603d6a8e5760d18e2/raw/ce24b46e2be28657f2956691812a7d8dd297ad2d";
// https://gist.githubusercontent.com/davidpetro88/f988fa8bd82cc8e603d6a8e5760d18e2/raw/ce24b46e2be28657f2956691812a7d8dd297ad2d/dashboard.json
class I18WebClient {
  final String _viewKey;

  I18WebClient(this._viewKey);

  Future<Map<String, dynamic>> findAll() async {
    print("$MESSSAGES_URI_PATH/$_viewKey.json");
    final Response response =
        await client.get(Uri.https(MESSSAGES_URI, "$MESSSAGES_URI_PATH/$_viewKey.json"));
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson;
  }
}
