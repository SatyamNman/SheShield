import 'package:flutter/material.dart';

class SOSButton extends StatefulWidget {
  const SOSButton({super.key});

  @override
  _SOSButtonState createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  void _toggleMenu() {
    setState(() {
      if (isExpanded) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (isExpanded) ...[
          Positioned(
            bottom: 100,
            child: ScaleTransition(
              scale: _animation,
              child: FloatingActionButton(
                heroTag: "call",
                onPressed: () {
                  // Implement emergency call function here
                  print("Calling Emergency...");
                },
                backgroundColor: Colors.red,
                child: Icon(Icons.call, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 160,
            child: ScaleTransition(
              scale: _animation,
              child: FloatingActionButton(
                heroTag: "send",
                onPressed: () {
                  // Implement SOS message function here
                  print("Sending SOS Message...");
                },
                backgroundColor: Colors.blue,
                child: Icon(Icons.message, color: Colors.white),
              ),
            ),
          ),
        ],
        FloatingActionButton(
          heroTag: "sos",
          onPressed: _toggleMenu,
          backgroundColor: Colors.pink,
          child: Icon(isExpanded ? Icons.close : Icons.warning, color: Colors.white),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
