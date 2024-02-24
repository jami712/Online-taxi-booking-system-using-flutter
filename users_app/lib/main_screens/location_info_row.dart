import 'package:flutter/material.dart';

class LocationInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String location;

  const LocationInfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.location,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
        ),
        const SizedBox(width: 15.0,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              location,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
