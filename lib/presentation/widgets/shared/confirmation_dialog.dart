import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onConfirmed;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: Text(description, textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onConfirmed();
            Navigator.of(context).pop(true);
          },
          child: const Text('Confirmar'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
