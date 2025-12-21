# Timezone Cubit - Architecture Overview

## Purpose
Manages timezone and location detection based on GPS coordinates, providing real-time updates of the current time in the user's detected timezone.

## Files Structure

```
lib/features/home/presentation/cubit/
├── timezone_cubit.dart    # Business logic for timezone management
└── timezone_state.dart    # State definitions
```

## How It Works

### 1. **TimezoneCubit** (Business Logic)
- **Initialization**: Automatically detects timezone on creation
- **GPS Detection**: Uses `LocationHelper.getTimezoneWithLocationName()` to determine:
  - Which timezone (Egypt or Saudi Arabia) based on GPS proximity to offices
  - Arabic location name (القاهرة or الرياض)
- **Real-time Clock**: Updates time every second using a Timer
- **Error Handling**: Falls back to Saudi Arabia timezone if GPS fails

### 2. **TimezoneState** (State Management)
Three states:
- `TimezoneInitial`: Before detection starts
- `TimezoneLoading`: During GPS location detection
- `TimezoneLoaded`: Contains timezone, location name, and current time

### 3. **TimezoneLoaded Features**
Helper methods for formatting:
- `getFormattedDateTime()`: Full date and time in Arabic (e.g., "21 ديسمبر 2025 | 3:45 مساءً")
- `getFormattedTime()`: Time only (e.g., "3:45 مساءً")
- `getFormattedDate()`: Date only (e.g., "21 ديسمبر 2025")

## Usage Example

### In Widget:

```dart
class HeaderAndShiftSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimezoneCubit(),
      child: BlocBuilder<TimezoneCubit, TimezoneState>(
        builder: (context, state) {
          if (state is TimezoneLoaded) {
            return Column(
              children: [
                Text(state.getFormattedDateTime()),
                Text(state.locationName),
              ],
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
```

### Refresh Timezone:

```dart
// After user grants location permission
context.read<TimezoneCubit>().refreshTimezone();
```

## Benefits

✅ **Separation of Concerns**: Logic is separated from UI  
✅ **Testable**: Cubit can be tested independently  
✅ **Reactive**: UI automatically updates when state changes  
✅ **Reusable**: Can be used in multiple widgets  
✅ **Clean**: Widget code is simplified and focused on presentation  
✅ **Memory Safe**: Timer is properly disposed when cubit closes

## Dependencies

- `flutter_bloc`: State management
- `equatable`: State comparison
- `LocationHelper`: GPS-based timezone detection
- `TimezoneHelper`: Timezone-aware time operations

