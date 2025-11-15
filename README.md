# Personalized Weather Dashboard - Flutter

**Student Index:** 224127A

## Coordinate Derivation

```
Index: 224127A
firstTwo = 22
nextTwo = 41

Latitude = 5 + (22 / 10.0) = 7.2°
Longitude = 79 + (41 / 10.0) = 83.1°
```

## Features

✅ Student index input with automatic coordinate calculation  
✅ Real-time weather data from Open-Meteo API  
✅ Displays temperature, wind speed, and weather code  
✅ Shows last updated timestamp  
✅ Request URL visible on screen  
✅ Loading indicator during API calls  
✅ Error handling with friendly messages  
✅ Offline caching using shared_preferences  
✅ "(cached)" tag when showing offline data  

## API Used

Open-Meteo Weather API (No API key required)
```
https://api.open-meteo.com/v1/forecast?latitude=7.2&longitude=83.1&current_weather=true
```

## Setup Instructions

1. **Prerequisites:**
   - Flutter SDK installed
   - Android Studio installed
   - Android emulator or physical device

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the App:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
  ├── main.dart                 # App entry point
  ├── models/
  │   └── weather_data.dart     # Weather data model
  ├── services/
  │   └── weather_service.dart  # API and caching service
  └── screens/
      └── weather_screen.dart   # Main UI screen
```

## Dependencies

- **http**: REST API calls
- **shared_preferences**: Local caching
- **intl**: Date formatting

## Testing Offline Mode

1. Run the app and fetch weather data
2. Enable Airplane Mode on your device
3. Tap "Fetch Weather" button
4. App will show cached data with "(cached)" tag

## Screenshots

(Add screenshots showing online and cached states with request URL visible)

## Deliverables Checklist

- [x] Index-to-coordinates conversion implemented
- [x] Open-Meteo API integration
- [x] JSON parsing for weather data
- [x] Loading indicator
- [x] Error handling
- [x] Offline caching with shared_preferences
- [x] Request URL displayed on screen
- [x] Last updated timestamp
- [x] Clean and readable UI
- [ ] Screenshots for report
- [ ] Video demonstration (≤60s)
- [ ] Report PDF (≤2 pages)

## Author

Student Index: 224127A  
Course: IN 3510 Wireless Communication & Mobile Networks  
University of Moratuwa
