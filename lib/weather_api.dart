import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getWeatherData(double lat, double lon) async {
  const apiKey = '99c9b656a553c7b77c12ddb91ec13c86';
  final url =
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}
