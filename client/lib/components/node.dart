import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Node extends StatefulWidget {
  const Node({required this.value, required this.onTap, super.key});

  final bool value;
  final VoidCallback onTap;

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
    _node = controller.findInput<bool>('PRessed') as SMIBool;
  }

  void _hitNode() => _node?.change(true);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () {
            widget.onTap();
            _hitNode();
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
