import 'package:weather_counter_app/weather_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart' as geo_locator;
import 'package:weather_counter_app/theme.dart';
import 'package:weather_counter_app/theme.dart' as app_theme;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.debugCheckInvalidValueType = null;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeProvider.getThemeData(),
      home: const MyHomePage(
        title: 'Weather Counter',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String _location = 'Press the icon to get the location';
  String _weather = '';
  String _temperature = '';

  void _incrementCounter() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    if (themeProvider.themeMode == app_theme.ThemeMode.light) {
      if (_counter < 10) {
        setState(() {
          _counter++;
        });
      }
    } else if (themeProvider.themeMode == app_theme.ThemeMode.dark) {
      if (_counter < 9) {
        setState(() {
          _counter += 2;
        });
      }
    }
  }

  void _decrementCounter() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    if (themeProvider.themeMode == app_theme.ThemeMode.light) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      }
    } else if (themeProvider.themeMode == app_theme.ThemeMode.dark) {
      if (_counter > 1) {
        setState(() {
          _counter -= 2;
        });
      }
    }
  }

  void _getCurrentLocation() async {
    final position = await geo_locator.Geolocator.getCurrentPosition();

    try {
      final weatherData =
          await getWeatherData(position.latitude, position.longitude);
      setState(() {
        _location = weatherData['name'];
        _weather = weatherData['weather'][0]['main'];
        _temperature =
            '${(weatherData['main']['temp'] - 273.15).toStringAsFixed(1)}°C';
      });
    } catch (e) {
      print('Failed to fetch weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _location,
              // style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              _weather,
              // style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              _temperature,
              // style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 30),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  elevation: 0,
                  child: const Icon(
                    Icons.cloud,
                  ),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  onPressed: () {
                    if (themeProvider.themeMode == app_theme.ThemeMode.light) {
                      themeProvider.themeMode = app_theme.ThemeMode.dark;
                    } else {
                      themeProvider.themeMode = app_theme.ThemeMode.light;
                    }
                  },
                  elevation: 0,
                  child: const Icon(
                    Icons.dark_mode,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Visibility(
                visible: _counter < 10,
                child: FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
              ),
              const SizedBox(height: 16),
              Visibility(
                visible: _counter > 0,
                child: FloatingActionButton(
                  onPressed: _decrementCounter,
                  tooltip: 'Decrement',
                  child: const Icon(Icons.remove),
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ],
      ),
    );
  }
}
