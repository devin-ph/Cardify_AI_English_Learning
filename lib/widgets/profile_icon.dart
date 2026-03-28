import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final VoidCallback onTap;
  const ProfileIcon({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.account_circle, size: 32, color: Colors.blue),
      onPressed: onTap,
      tooltip: 'Hồ sơ',
    );
  }
}
