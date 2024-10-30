import 'package:http/http.dart' as http;

class NetworkUtil {
  static Future<http.Response> fetch(String url) async {
    return await http.get(Uri.parse(url));
  }

  // examine response fields like: response.statusCode and response.body
  static Future<http.Response> post(String url, Map data) async {
    return await http.post(Uri.parse(url), body: data);
  }

  static Future<http.Response> dummyfetch(String url) async {
    http.Response response = http.Response(courses, 200);
    return response;
  }

  static String courses = r'''{"data":[
  {"course": "Learn PHPabcdefghop",
  "type":  "self-paced",
  "price": "5",
  "currency": "USD",
  "description": "Beginners PHP Course that will really help you get started"},
{"course": "Learn Java",
"type":  "self-paced",
"price": "5",
"currency": "USD",
"description": "Beginners Java Course that will teach you how to create simple command line and desktop apps with Java"},
{"course": "Learn VueJS",
"type":  "self-paced",
"price": "5",
"currency": "USD",
"description": "Beginners VueJs Course that will get you started in no time with creating VueJs Apps for the web"},
{"course": "Learn Flutter",
"type":  "self-paced",
"price": "5",
"currency": "USD",
"description": "Beginners Flutter Course that covers the basics of Dart and Flutter"}
]}
''';
}
