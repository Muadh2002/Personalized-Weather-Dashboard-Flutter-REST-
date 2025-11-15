import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';

class WeatherService {
  static const String _cacheKey = 'cached_weather_data';

  Future<WeatherData> fetchWeather(double lat, double lon) async {
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';

    try {
      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final currentWeather = data['current_weather'];

        final weatherData = WeatherData(
          temperature: currentWeather['temperature'].toDouble(),
          windSpeed: currentWeather['windspeed'].toDouble(),
          weatherCode: currentWeather['weathercode'],
          lastUpdated: DateTime.now(),
          isCached: false,
        );

        // Cache the successful result
        await _cacheWeatherData(weatherData);

        return weatherData;
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Try to return cached data if available
      final cachedData = await getCachedWeather();
      if (cachedData != null) {
        throw Exception('Network error. Showing cached data.');
      }
      throw Exception('Failed to fetch weather: $e');
    }
  }

  Future<void> _cacheWeatherData(WeatherData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_cacheKey, jsonString);
  }

  Future<WeatherData?> getCachedWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cacheKey);

      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return WeatherData.fromJson(json);
      }
    } catch (e) {
      print('Error loading cached data: $e');
    }
    return null;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
