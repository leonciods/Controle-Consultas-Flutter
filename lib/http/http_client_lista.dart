import 'package:http/http.dart' as Http;

abstract class IHttpClientLista {
  Future get({required String url});
  Future post({required String url, required String body});
  Future delete({required String url});
  Future update({required String url, required String body});
}


class HttpClientLista implements IHttpClientLista {

  final client = Http.Client();
  @override
  Future get({required String url}) async {
    // Implement the HTTP GET request logic here
    return await client.get(Uri.parse(url));
  }

  @override
  Future post({required String url, required String body}) async {
    // Implement the HTTP POST request logic here
    return await client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'}, 
      body: body,
      );
  }

  @override
  Future delete({required String url}) async {
    // Implement the HTTP DELETE request logic here
    return await client.delete(Uri.parse(url));
  }

  @override
  Future update({required String url, required String body}) async {
    return await client.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'}, 
      body: body,
    );
  }

}
