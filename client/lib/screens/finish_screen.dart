import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class FinishScreen extends StatelessWidget {
  const FinishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: RiveAnimation.asset(
            'finish.riv',
            fit: BoxFit.fitHeight,
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                child: const Text('Go to rooms list'),
                onPressed: () {
                  Navigator.of(context).pop();
                }))
      ],
    );
  }
}
