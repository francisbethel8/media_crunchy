import 'package:flutter/material.dart';

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Container(
            height: 220,

            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),

            child: const Center(child: Icon(Icons.play_circle_fill, size: 80)),
          ),

          const SizedBox(height: 20),

          const Text(
            'Cyber Samurai Episode 1',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            'A futuristic warrior fights rogue AI forces in Neo Tokyo.',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),

          const SizedBox(height: 30),

          const Text(
            'Episodes',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Column(
            children: List.generate(
              5,
              (index) => Container(
                margin: const EdgeInsets.only(bottom: 12),

                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 60,

                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: const Icon(Icons.play_arrow),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'Episode ${index + 1}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Related AI Anime',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 220,

            child: ListView(
              scrollDirection: Axis.horizontal,

              children: [
                _relatedCard('AI Wars'),
                _relatedCard('Neon Future'),
                _relatedCard('Mecha X'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _relatedCard(String title) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),

      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),

              child: const Center(child: Icon(Icons.movie)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
