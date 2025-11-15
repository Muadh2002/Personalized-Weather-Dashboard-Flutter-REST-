# Personalized Weather Dashboard - Flutter (Android)

**Student Index:** 224127A  
**Course:** IN 3510 Wireless Communication & Mobile Networks  
**University:** University of Moratuwa  
**Platform:** Android Only

## Coordinate Derivation Formula

```
Index: 224127A
firstTwo = int(index[0..1]) = 22
nextTwo = int(index[2..3]) = 41

Latitude = 5 + (firstTwo / 10.0) = 5 + 2.2 = 7.2°
Longitude = 79 + (nextTwo / 10.0) = 79 + 4.1 = 83.1°
```

## Features (Assignment Requirements)

✅ **Required Features:**
- Text input for student index (pre-filled with 224127A)
- Automatic coordinate calculation and display (2 decimals)
- "Fetch Weather" button with loading indicator
- Displays: Temperature (°C), Wind speed, Weather code
- Shows last updated timestamp (device clock)
- Request URL displayed on screen (tiny text for verification)
- Error handling with friendly messages
- Offline caching using shared_preferences
- "(cached)" tag when showing offline data

## Weather API

**Open-Meteo** (No API key required)
```
https://api.open-meteo.com/v1/forecast?latitude=7.2&longitude=83.1&current_weather=true
```

## Project Structure

```
lib/
  ├── main.dart                 # App entry point
  ├── models/
  │   └── weather_data.dart     # Weather data model with JSON parsing
  ├── services/
  │   └── weather_service.dart  # API calls & offline caching
  └── screens/
      └── weather_screen.dart   # Main UI screen
android/                         # Android platform files only
```

## Setup & Run

### Prerequisites:
- Flutter SDK installed
- Android Studio with Android SDK
- Android emulator or physical device

### Installation:
```bash
# 1. Install dependencies
flutter pub get

# 2. Run on Android device/emulator
flutter run

# Or build APK
flutter build apk
```

## Dependencies

```yaml
dependencies:
  http: ^1.1.0              # REST API calls
  shared_preferences: ^2.2.2 # Local caching
  intl: ^0.18.1             # Date formatting
```

## Testing Offline Mode (For Video Demo)

1. Run the app and enter index (224127A)
2. Tap "Fetch Weather" → Shows live data with timestamp
3. Enable Airplane Mode on device
4. Tap "Fetch Weather" again
5. App shows cached data with "(cached)" tag and friendly error message

## Assignment Deliverables

### ✅ Completed:
- [x] Index-to-coordinates conversion (shown in UI)
- [x] Open-Meteo API integration with JSON parsing
- [x] Loading indicator during fetch
- [x] Error handling (network errors, timeouts)
- [x] Offline caching with shared_preferences
- [x] Request URL visible on screen
- [x] Last updated timestamp
- [x] Clean, readable UI with proper labels

### 📝 To Complete:
- [ ] Screenshots (with request URL visible)
- [ ] Video demo (≤60s: online + offline/cached mode)
- [ ] Report PDF (≤2 pages: index, formula, coords, screenshots, reflection)

## Technical Implementation

### Coordinate Calculation:
- Reads first 2 digits of index for latitude calculation
- Reads next 2 digits (positions 2-3) for longitude calculation
- Validates input and shows error for invalid formats

### API Integration:
- HTTP GET request to Open-Meteo API
- 10-second timeout with custom error handling
- Parses JSON response for temperature, wind speed, weather code
- Caches successful responses locally

### Offline Support:
- Stores last successful weather data in shared_preferences
- Returns cached data when network is unavailable
- Displays "(cached)" tag to indicate offline data
- Shows user-friendly error messages

---

**Student:** 224127A  
**Faculty:** Information Technology  
**Program:** B.Sc. (Hons) IT&M - Level 3 Semester 5
