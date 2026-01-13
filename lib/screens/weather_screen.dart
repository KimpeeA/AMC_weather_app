import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  late Future<Weather> weatherFuture;
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    weatherFuture = WeatherService.getWeather('Manila'); // Default to Manila
  }

  void _searchWeather() {
    final String city = _cityController.text.trim();
    if (city.isEmpty) {
      _showSnackBar('Please enter a city name', Colors.orangeAccent);
      return;
    }
    setState(() {
      weatherFuture = WeatherService.getWeather(city);
      isFirstLoad = false;
    });
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Vibrant animated-style background
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade900,
              Colors.blue.shade700,
              Colors.lightBlue.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildHeader(),
                const SizedBox(height: 20),
                _buildSearchField(),
                const SizedBox(height: 30),
                _buildWeatherDisplay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      '🌤️ Weather App',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search city...',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _searchWeather(),
            ),
          ),
          IconButton(
            onPressed: _searchWeather,
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDisplay() {
    return FutureBuilder<Weather>(
      future: weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (snapshot.hasError) {
          return _buildStatusMessage(
            Icons.cloud_off,
            snapshot.error.toString().replaceFirst('Exception: ', ''),
            Colors.white70,
          );
        }

        if (snapshot.hasData) {
          final weather = snapshot.data!;
          // Animated Appearance
          return TweenAnimationBuilder(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: _buildWeatherCard(weather),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildWeatherCard(Weather weather) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            weather.city.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${weather.temperature.toStringAsFixed(0)}°',
            style: const TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Divider(color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCompactInfo(Icons.water_drop, '${weather.humidity}%', 'Humidity'),
              _buildCompactInfo(Icons.air, '${weather.windSpeed}m/s', 'Wind'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildStatusMessage(IconData icon, String message, Color color) {
    return Column(
      children: [
        Icon(icon, size: 60, color: color),
        const SizedBox(height: 10),
        Text(message, style: TextStyle(color: color, fontSize: 16), textAlign: TextAlign.center),
      ],
    );
  }
}