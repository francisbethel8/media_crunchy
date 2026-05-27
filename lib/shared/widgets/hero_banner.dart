import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        gradient: LinearGradient(
          colors: [Colors.red.shade900, Colors.black],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,

          children: [
            const Text(
              'CYBER SAMURAI',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'An AI-generated futuristic anime series.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {},

              icon: const Icon(Icons.play_arrow),

              label: const Text('Watch Now'),
            ),
          ],
        ),
      ),
    );
  }
}
