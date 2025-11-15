import 'dart:convert';
import 'package:flutter/foundation.dart';
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
        onTimeout: () {
          throw Exception(
              'Request timeout - please check your internet connection');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Validate response structure
        if (data['current_weather'] == null) {
          throw Exception('Invalid response format from weather API');
        }

        final currentWeather = data['current_weather'];

        final weatherData = WeatherData(
          temperature: (currentWeather['temperature'] as num).toDouble(),
          windSpeed: (currentWeather['windspeed'] as num).toDouble(),
          weatherCode: currentWeather['weathercode'] as int,
          lastUpdated: DateTime.now(),
          isCached: false,
        );

        // Cache the successful result
        await _cacheWeatherData(weatherData);

        return weatherData;
      } else {
        throw Exception(
            'Failed to load weather data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Try to return cached data if available
      final cachedData = await getCachedWeather();
      if (cachedData != null) {
        return cachedData.copyWith(isCached: true);
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
      // Silently fail and return null if cache is corrupted
      debugPrint('Error loading cached data: $e');
    }
    return null;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
