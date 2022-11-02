import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  SMIBool? _node;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, 'State Machine 1',
        onStateChange: (machine, event) {});
    artboard.addController(controller!);
    _node = controller.findInput<bool>('Boolean 1') as SMIBool;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _node?.change(true);
      },
      onExit: (_) {
        _node?.change(false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
            width: 300,
            height: 200,
            child: Stack(
              children: [
                RiveAnimation.asset(
                  'button.riv',
                  onInit: _onRiveInit,
                ),
                const Center(
                  child: Text('Start game',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                )
              ],
            )),
      ),
    );
  }
}
