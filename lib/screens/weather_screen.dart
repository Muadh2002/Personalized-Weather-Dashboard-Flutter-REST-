import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _indexController =
      TextEditingController(text: '224127A');
  final WeatherService _weatherService = WeatherService();

  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;
  double? _latitude;
  double? _longitude;
  String? _requestUrl;

  @override
  void initState() {
    super.initState();
    _calculateCoordinates();
    _loadCachedData();
  }

  void _calculateCoordinates() {
    final index = _indexController.text.trim();
    if (index.length >= 4) {
      try {
        final firstTwo = int.parse(index.substring(0, 2));
        final nextTwo = int.parse(index.substring(2, 4));

        setState(() {
          _latitude = 5 + (firstTwo / 10.0);
          _longitude = 79 + (nextTwo / 10.0);
          _requestUrl =
              'https://api.open-meteo.com/v1/forecast?latitude=${_latitude!.toStringAsFixed(1)}&longitude=${_longitude!.toStringAsFixed(1)}&current_weather=true';
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Invalid index format';
        });
      }
    }
  }

  Future<void> _loadCachedData() async {
    final cachedData = await _weatherService.getCachedWeather();
    if (cachedData != null && _weatherData == null) {
      setState(() {
        _weatherData = cachedData;
      });
    }
  }

  Future<void> _fetchWeather() async {
    if (_latitude == null || _longitude == null) {
      setState(() {
        _errorMessage = 'Please enter a valid student index';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weatherData =
          await _weatherService.fetchWeather(_latitude!, _longitude!);
      setState(() {
        _weatherData = weatherData;
        _isLoading = false;
      });
    } catch (e) {
      // Check if we have cached data
      final cachedData = await _weatherService.getCachedWeather();
      setState(() {
        _isLoading = false;
        if (cachedData != null) {
          _weatherData = cachedData;
          _errorMessage = 'Network error. Showing cached data.';
        } else {
          _errorMessage = e.toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Student Index Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student Index',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _indexController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Index Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (value) => _calculateCoordinates(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Coordinates Card
            if (_latitude != null && _longitude != null)
              Card(
                elevation: 4,
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Computed Coordinates',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.location_on, color: Colors.blue),
                              const SizedBox(height: 4),
                              const Text('Latitude'),
                              Text(
                                _latitude!.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.green),
                              const SizedBox(height: 4),
                              const Text('Longitude'),
                              Text(
                                _longitude!.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Fetch Weather Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchWeather,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.cloud_download),
              label: Text(_isLoading ? 'Fetching...' : 'Fetch Weather'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),

            // Error Message
            if (_errorMessage != null)
              Card(
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Weather Data Card
            if (_weatherData != null)
              Card(
                elevation: 4,
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Weather Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_weatherData!.isCached)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '(cached)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildWeatherRow(
                        Icons.thermostat,
                        'Temperature',
                        '${_weatherData!.temperature.toStringAsFixed(1)} °C',
                        Colors.red,
                      ),
                      const SizedBox(height: 12),
                      _buildWeatherRow(
                        Icons.air,
                        'Wind Speed',
                        '${_weatherData!.windSpeed.toStringAsFixed(1)} km/h',
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildWeatherRow(
                        Icons.wb_sunny,
                        'Weather Code',
                        '${_weatherData!.weatherCode}',
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _buildWeatherRow(
                        Icons.access_time,
                        'Last Updated',
                        DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(_weatherData!.lastUpdated),
                        Colors.purple,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Request URL Card
            if (_requestUrl != null)
              Card(
                elevation: 2,
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Request URL:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        _requestUrl!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _indexController.dispose();
    super.dispose();
  }
}
