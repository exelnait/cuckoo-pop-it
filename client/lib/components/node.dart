import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Node extends StatefulWidget {
  const Node({required this.value, required this.onTap, this.color, super.key});

  final bool value;
  final VoidCallback onTap;
  final Color? color;

  @override
  State<Node> createState() => _NodeState();
}

class _NodeState extends State<Node> {
  SMIBool? _node;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, 'State Machine 1',
        onStateChange: (machine, event) {});
    artboard.addController(controller!);
    _node = controller.findInput<bool>('Pressed') as SMIBool;
  }

  @override
  Widget build(BuildContext context) {
    _node?.change(widget.value);

    return Container(
        height: 75,
        width: 75,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: widget.color ?? Colors.transparent, width: 3)),
        child: GestureDetector(
          onTap: () {
            widget.onTap();
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: RiveAnimation.asset(
                'node.riv',
                fit: BoxFit.cover,
                onInit: _onRiveInit,
              )),
        ));
  }
}
