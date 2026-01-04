import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_launcher/map_launcher.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class ActiveStop extends ConsumerWidget {
  const ActiveStop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapNotifier = ref.read(mapProvider.notifier);
    final stop = ref.watch(mapProvider).selectedStop;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (stop == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  stop.address,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  mapNotifier.clearSelectedStop();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '1/3, 21:22',
                style: textTheme.bodySmall?.copyWith(
                  color: textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _openMaps(context, stop),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.navigation),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.close, color: Colors.red),
                        SizedBox(height: 6),
                        Text('Fallida'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check_circle_outline, color: Colors.green),
                        SizedBox(height: 6),
                        Text('Entregada'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoTile(icon: Icons.place_outlined, title: stop.address),
          const SizedBox(height: 8),
          _ActionTile(
            icon: Icons.edit_location_alt_outlined,
            title: 'Editar parada',
            onTap: () {
              showGeneralDialog(
                context: context,
                barrierColor: Colors.black54,
                barrierDismissible: true,
                barrierLabel: 'close-stop-details',
                transitionDuration: const Duration(milliseconds: 250),
                pageBuilder: (_, __, ___) {
                  return const StopDetailPage();
                },
              );
            },
          ),
          _ActionTile(
            icon: Icons.delete_outline,
            title: 'Eliminar parada',
            color: theme.colorScheme.error,
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => ConfirmationDialog(
                  title: 'Eliminar parada',
                  description: '¿Estás seguro que desea eliminar la parada?',
                  onConfirmed: () {},
                ),
              );
              if (confirmed != true) return;

              final deleted = await ref
                  .read(mapProvider.notifier)
                  .deleteStop(stop);
              if (deleted && context.mounted) {
                ref.read(mapProvider.notifier).clearSelectedStop();
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _openMaps(BuildContext context, Stop stop) async {
  final availableMaps = await MapLauncher.installedMaps;
  if (!context.mounted) return;
  if (availableMaps.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No hay apps de mapas instaladas.')),
    );
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    builder: (bottomSheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final map in availableMaps)
              ListTile(
                leading: const Icon(Icons.map_outlined),
                title: Text(map.mapName),
                onTap: () {
                  Navigator.of(bottomSheetContext).pop();
                  map.showMarker(
                    coords: Coords(stop.latitude, stop.longitude),
                    title: stop.address,
                  );
                },
              ),
          ],
        ),
      );
    },
  );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;

  const _InfoTile({required this.icon, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: theme.colorScheme.primary),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: () {},
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tileColor = color ?? theme.colorScheme.onSurface;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: tileColor),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: tileColor),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
