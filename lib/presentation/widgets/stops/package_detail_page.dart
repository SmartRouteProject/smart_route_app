import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/domain/domain.dart';

class PackageDetailPage extends StatelessWidget {
  final Package package;

  const PackageDetailPage({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final description = package.description.trim().isEmpty
        ? 'Sin descripcion'
        : package.description.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del paquete'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        child: package.picture != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  package.picture!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 32,
                                  ),
                                  SizedBox(height: 8),
                                  Text('Sin foto'),
                                ],
                              ),
                      ),
                      _ReadOnlyField(label: 'Descripcion', value: description),
                      _ReadOnlyField(
                        label: 'Peso',
                        value: package.weight.label,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: Text(value),
    );
  }
}
