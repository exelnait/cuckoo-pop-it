import 'package:flutter/material.dart';

class Node extends StatelessWidget {
  const Node({required this.value, required this.onTap, super.key});

  final int value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          decoration:
              const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          child: Text(value.toString())),
    );
  }
}
