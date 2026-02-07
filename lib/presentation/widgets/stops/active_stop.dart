import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class ActiveStop extends ConsumerWidget {
  const ActiveStop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapNotifier = ref.read(mapProvider.notifier);
    final mapState = ref.watch(mapProvider);
    final stop = mapState.selectedStop;
    final selectedRoute = mapState.selectedRoute;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (stop == null) {
      return const SizedBox.shrink();
    }

    final canEditStop =
        stop.status == StopStatus.pending &&
        selectedRoute?.state != RouteState.completed;
    final totalStops = selectedRoute?.stops.length ?? 0;
    final positionLabel = totalStops > 0
        ? '${stop.order}/$totalStops'
        : totalStops > 0
        ? '-/$totalStops'
        : '0/0';
    final showClosedTime =
        stop.status != StopStatus.pending && stop.closedTime != null;
    final closedTimeLabel = showClosedTime
        ? DateFormat('HH:mm').format(stop.closedTime!.toLocal())
        : null;
    final positionText = showClosedTime
        ? '$positionLabel - $closedTimeLabel'
        : positionLabel;

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
                positionText,
                style: textTheme.bodySmall?.copyWith(
                  color: textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 12),
              _StatusBadge(status: stop.status),
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
              if (canEditStop) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () async {
                        await ref
                            .read(mapProvider.notifier)
                            .updateStopStatus(stop, StopStatus.failed);
                      },
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
                      onPressed: () async {
                        await ref
                            .read(mapProvider.notifier)
                            .updateStopStatus(stop, StopStatus.succeeded);
                      },
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
                          Text('Exitosa'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          if (canEditStop && selectedRoute?.state == RouteState.planned) ...[
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

class _StatusBadge extends StatelessWidget {
  final StopStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _statusColors(theme, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

_StatusColors _statusColors(ThemeData theme, StopStatus status) {
  switch (status) {
    case StopStatus.failed:
      return _StatusColors(
        background: theme.colorScheme.error.withValues(alpha: 0.12),
        foreground: theme.colorScheme.error,
      );
    case StopStatus.succeeded:
      return _StatusColors(
        background: Colors.green.withValues(alpha: 0.12),
        foreground: Colors.green,
      );
    case StopStatus.pending:
      return _StatusColors(
        background: Colors.grey.withValues(alpha: 0.2),
        foreground: Colors.grey.shade700,
      );
  }
}

class _StatusColors {
  final Color background;
  final Color foreground;

  const _StatusColors({required this.background, required this.foreground});
}
