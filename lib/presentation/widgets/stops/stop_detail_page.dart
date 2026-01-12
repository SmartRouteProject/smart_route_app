import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class StopDetailPage extends ConsumerWidget {
  const StopDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final selectedStop = ref.watch(
      mapProvider.select((state) => state.selectedStop),
    );
    if (selectedStop == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
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
        body: const Center(child: Text('Sin parada seleccionada.')),
      );
    }

    final stopForm = ref.watch(stopFormProvider(selectedStop));
    final stopFormNotifier = ref.read(stopFormProvider(selectedStop).notifier);
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
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
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.25),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_shipping_outlined),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text('Tipo', style: infoTitleStyle),
                              ),
                              SegmentedButton<StopType>(
                                style: SegmentedButton.styleFrom(
                                  selectedForegroundColor: Colors.white,
                                  selectedBackgroundColor:
                                      theme.colorScheme.primary,
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
                                  stopFormNotifier.onTypeChanged(
                                    selection.first,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      _InfoTile(
                        icon: Icons.schedule,
                        title: 'Hora de llegada',
                        subtitle: stopForm.arrivalTime,
                        trailingText: 'Editar',
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked == null) return;
                          final formatted = _formatTime(picked);
                          stopFormNotifier.onArrivalTimeChanged(formatted);
                        },
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
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          child: ListTile(
                            leading: Icon(Icons.inventory_2_outlined),
                            title: Text('Paquetes asignados'),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              showGeneralDialog(
                                context: context,
                                barrierColor: Colors.black54,
                                barrierDismissible: true,
                                barrierLabel: 'close-packages-list',
                                transitionDuration: const Duration(
                                  milliseconds: 250,
                                ),
                                pageBuilder: (_, __, ___) {
                                  return const AssignedPackagesList();
                                },
                              );
                            },
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
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        child: ListTile(
                          onTap: () async {
                            await showSearch<String?>(
                              context: context,
                              delegate: AddressSearchDelegate(
                                onSelectedResult:
                                    stopFormNotifier.onAddressSelected,
                              ),
                            );
                          },
                          leading: const Icon(Icons.edit_location_alt_outlined),
                          title: const Text('Cambiar dirección'),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Eliminar parada (en rojo)
                      Card(
                        elevation: 0,
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        child: ListTile(
                          onTap: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => ConfirmationDialog(
                                title: 'Eliminar parada',
                                description:
                                    '¿Está seguro que desea eliminar la parada?',
                                onConfirmed: () {},
                              ),
                            );
                            if (confirmed != true) return;

                            final deleted = await ref
                                .read(mapProvider.notifier)
                                .deleteStop(selectedStop);
                            if (deleted && context.mounted) {
                              context.pop();
                            }
                          },
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

                      const SizedBox(height: 4),

                      // Botón guardar cambios
                      SizedBox(
                        width: double.infinity,
                        child: LoadingFloatingActionButton(
                          label: 'Guardar',
                          loader: stopForm.isPosting,
                          onPressed: () async {
                            final saved = await stopFormNotifier.onSubmit();
                            if (saved && context.mounted) {
                              context.pop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
  final VoidCallback? onTap;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailingText,
    this.onTap,
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
        onTap: onTap, // solo visual
      ),
    );
  }
}

String _formatTime(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
