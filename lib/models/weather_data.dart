class WeatherData {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final DateTime lastUpdated;
  final bool isCached;

  WeatherData({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.lastUpdated,
    this.isCached = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'windSpeed': windSpeed,
      'weatherCode': weatherCode,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['temperature'].toDouble(),
      windSpeed: json['windSpeed'].toDouble(),
      weatherCode: json['weatherCode'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      isCached: true,
    );
  }

  WeatherData copyWith({bool? isCached}) {
    return WeatherData(
      temperature: temperature,
      windSpeed: windSpeed,
      weatherCode: weatherCode,
      lastUpdated: lastUpdated,
      isCached: isCached ?? this.isCached,
    );
  }
}
