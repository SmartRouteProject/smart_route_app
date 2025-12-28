import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';

class StopDetailPage extends ConsumerWidget {
  final Stop stop;

  const StopDetailPage({super.key, required this.stop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final stopForm = ref.watch(stopFormProvider(stop));
    final stopFormNotifier = ref.read(stopFormProvider(stop).notifier);
    final infoTitleStyle = textTheme.bodySmall?.copyWith(
      color: textTheme.bodySmall?.color?.withValues(alpha: 0.8),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface, // similar a fondo oscuro
      appBar: AppBar(
        title: const Text('Editar parada'),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dirección principal
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Puntito de color / icono
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 6, right: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stopForm.address,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sección "Información"
              Text(
                'Detalles',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.25,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined),
                      const SizedBox(width: 12),
                      Expanded(child: Text('Tipo', style: infoTitleStyle)),
                      SegmentedButton<StopType>(
                        style: SegmentedButton.styleFrom(
                          selectedForegroundColor: Colors.white,
                          selectedBackgroundColor: theme.colorScheme.primary,
                        ),
                        segments: const [
                          ButtonSegment(
                            value: StopType.delivery,
                            label: Text('Entrega'),
                          ),
                          ButtonSegment(
                            value: StopType.pickup,
                            label: Text('Recogida'),
                          ),
                        ],
                        selected: {stopForm.selectedType},
                        showSelectedIcon: false,
                        onSelectionChanged: (selection) {
                          if (selection.isEmpty) return;
                          stopFormNotifier.onTypeChanged(selection.first);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _InfoTile(
                icon: Icons.schedule,
                title: 'Hora de llegada',
                subtitle: stopForm.arrivalTimeLabel,
                trailingText: 'Editar',
              ),
              const SizedBox(height: 16),
              Text(
                'Descripción',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: stopForm.description,
                minLines: 3,
                maxLines: 5,
                onChanged: stopFormNotifier.onDescriptionChanged,
                decoration: InputDecoration(
                  hintText: 'Agrega una descripción para esta parada',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.25),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              if (stopForm.selectedType == StopType.delivery) ...[
                Text(
                  'Paquetes',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  child: ListTile(
                    leading: Icon(Icons.inventory_2_outlined),
                    title: Text('Paquetes asignados'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Acciones (solo Cambiar / Eliminar)
              Text(
                'Acciones',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Cambiar dirección
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                child: ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.edit_location_alt_outlined),
                  title: const Text('Cambiar dirección'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),

              const SizedBox(height: 4),

              // Eliminar parada (en rojo)
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                child: ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error,
                  ),
                  title: Text(
                    'Eliminar parada',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: textTheme.bodySmall?.copyWith(
            color: textTheme.bodySmall?.color?.withValues(alpha: 0.8),
          ),
        ),
        subtitle: Text(subtitle, style: textTheme.bodyMedium),
        trailing: trailingText != null
            ? Text(
                trailingText!,
                style: textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              )
            : null,
        onTap: () {}, // solo visual
      ),
    );
  }
}
