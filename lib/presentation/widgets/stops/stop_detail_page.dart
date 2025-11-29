import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/domain/domain.dart';

class StopDetailPage extends StatelessWidget {
  final Stop stop;

  const StopDetailPage({super.key, required this.stop});

  String get _typeLabel {
    if (stop is DeliveryStop) return 'Entrega';
    if (stop is PickupStop) return 'Recogida';
    return 'Parada';
  }

  String get _statusLabel {
    switch (stop.status) {
      case StopStatus.pending:
        return 'Pendiente';
      case StopStatus.failed:
        return 'Fallida';
      case StopStatus.succeded:
        return 'Completada';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

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
                          stop.address,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Montevideo, Uruguay', // mock, podés cambiarlo
                          style: textTheme.bodySmall?.copyWith(
                            color: textTheme.bodySmall?.color?.withOpacity(0.7),
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

              _InfoTile(
                icon: Icons.local_shipping_outlined,
                title: 'Tipo',
                subtitle: _typeLabel,
              ),
              _InfoTile(
                icon: Icons.flag_outlined,
                title: 'Estado',
                subtitle: _statusLabel,
              ),
              _InfoTile(
                icon: Icons.schedule,
                title: 'Hora de llegada',
                subtitle: 'Cualquier hora',
                trailingText: 'Editar',
              ),
              _InfoTile(
                icon: Icons.timer_outlined,
                title: 'Tiempo estimado en parada',
                subtitle: 'Predeterminado (1 min)',
              ),

              const SizedBox(height: 32),

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
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
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
      color: theme.colorScheme.surfaceVariant.withOpacity(0.25),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: textTheme.bodySmall?.copyWith(
            color: textTheme.bodySmall?.color?.withOpacity(0.8),
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
