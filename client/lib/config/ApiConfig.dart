class Apiconfig {

  static const String baseURL = 'http://localhost:8081/';

  final Object allEndpoints = {
    'user-register': '${baseURL}user-reg',
    'merchant-register': '${baseURL}merchant-reg',
    'login': '${baseURL}login',
    'me': '${baseURL}me'
  };
}