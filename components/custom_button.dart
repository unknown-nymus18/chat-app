import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function() onpressed;
  final Widget child;
  const CustomButton({
    super.key,
    required this.onpressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.black),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        fixedSize: WidgetStatePropertyAll(
          Size(270, 50),
        ),
      ),
      child: child,
    );
  }
}
