import 'package:flutter/material.dart';

class LoadingFloatingActionButton extends StatelessWidget {
  final String label;
  final bool loader;
  final VoidCallback onPressed;

  const LoadingFloatingActionButton({
    super.key,
    required this.label,
    required this.loader,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: null,
      onPressed: loader ? null : onPressed,
      label: loader
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(label),
      elevation: 0,
    );
  }
}
