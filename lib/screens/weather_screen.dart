import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For ideal simulation before backend binds we use mock values.
    // Represents a sunny nice day scenario.
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CA1AF), Color(0xFFC4E0E5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Tashkent, UZ',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tuesday, 10:00 AM',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              const Icon(
                Icons.wb_sunny_rounded,
                size: 100,
                color: Colors.amber,
              ),
              const SizedBox(height: 20),
              const Text(
                '24°C',
                style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Text(
                'Clear Sky',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              const Spacer(),
              _buildInfoRow(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(Icons.water_drop, 'Humidity', '45%'),
          _buildInfoItem(Icons.air, 'Wind', '10 km/h'),
          _buildInfoItem(Icons.remove_red_eye, 'Visibility', '10 km'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
