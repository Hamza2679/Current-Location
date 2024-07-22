import 'package:flutter/material.dart';

class InformationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const InformationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      onPressed: onPressed,
      child: Text('Get Information'),

    );
  }
}
