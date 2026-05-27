import 'package:flutter/material.dart';

class CreatorCard extends StatelessWidget {
  final String creatorName;

  const CreatorCard({super.key, required this.creatorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,

      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 28, child: Icon(Icons.person)),

          const SizedBox(height: 10),

          Text(creatorName, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
