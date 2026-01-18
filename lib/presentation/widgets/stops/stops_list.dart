import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/map_provider.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

//TODO: la ultima parada queda cortada por los botones de mas abajo
//TODO: Si la ruta esta completada, no mostrar el input text para agregar paradas
class StopsList extends ConsumerStatefulWidget {
  const StopsList({super.key});

  @override
  ConsumerState<StopsList> createState() => _StopsListState();
}

class _StopsListState extends ConsumerState<StopsList> {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _isDialogOpen = false;
  bool _isFinishing = false;
  String _lastWords = '';

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  void _showListeningDialog(BuildContext context) {
    if (_isDialogOpen) return;
    _isDialogOpen = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(child: Text('Escuchando...')),
            ],
          ),
        );
      },
    );
  }

  void _closeListeningDialog(BuildContext context) {
    if (!_isDialogOpen) return;
    _isDialogOpen = false;
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> _finishListening(BuildContext context) async {
    if (_isFinishing) return;
    _isFinishing = true;
    await _speech.stop();
    if (!mounted) return;
    setState(() => _isListening = false);
    _closeListeningDialog(context);
    final words = _lastWords.trim();
    _isFinishing = false;
    if (words.isEmpty) return;
    await showSearch(
      context: context,
      delegate: AddressSearchDelegate(),
      query: words,
    );
  }

  Future<void> _startVoiceSearch(BuildContext context) async {
    if (_isListening) return;
    final available = await _speech.initialize();
    if (!available) return;

    if (!mounted) return;
    _lastWords = '';
    setState(() => _isListening = true);
    _showListeningDialog(context);

    await _speech.listen(
      pauseFor: const Duration(seconds: 3),
      onResult: (result) async {
        _lastWords = result.recognizedWords;
        if (!result.finalResult) return;
        await _finishListening(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final mapNotifier = ref.read(mapProvider.notifier);
    final returnAddress = mapState.selectedRoute?.returnAddress;
    final selectedRoute = mapState.selectedRoute;
    final routeName = selectedRoute?.name ?? 'Ruta sin nombre';
    final stops = selectedRoute?.stops ?? [];
    final orderedStops = List<Stop>.from(stops)
      ..sort((a, b) {
        final aOrder = a.order ?? 1 << 30;
        final bOrder = b.order ?? 1 << 30;
        if (aOrder != bOrder) return aOrder.compareTo(bOrder);
        return a.address.compareTo(b.address);
      });

    return SafeArea(
      top: false,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              onTap: () async {
                await showSearch(
                  context: context,
                  delegate: AddressSearchDelegate(),
                );
              },
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Excribe para añadir una parada",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: _isListening
                      ? null
                      : () => _startVoiceSearch(context),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                routeName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: selectedRoute == null
                  ? null
                  : _RouteStatusBadge(status: selectedRoute.state),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.home_outlined),
              title: Text(
                returnAddress != null
                    ? (returnAddress.nickname.isNotEmpty
                          ? returnAddress.nickname
                          : returnAddress.address)
                    : 'Sin direccion de retorno',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {},
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: orderedStops.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  leading: Icon(Icons.route),
                  title: Text(
                    'Parada #${orderedStops[index].order ?? index + 1}',
                  ),
                  subtitle: Text(
                    orderedStops[index].address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    if (selectedRoute?.state == RouteState.started) {
                      mapNotifier.selectStop(orderedStops[index]);
                      return;
                    }
                    mapNotifier.selectStop(orderedStops[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteStatusBadge extends StatelessWidget {
  final RouteState status;

  const _RouteStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _routeStatusColors(theme, status);

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

_StatusColors _routeStatusColors(ThemeData theme, RouteState status) {
  switch (status) {
    case RouteState.completed:
      return _StatusColors(
        background: Colors.green.withValues(alpha: 0.12),
        foreground: Colors.green,
      );
    case RouteState.started:
      return _StatusColors(
        background: theme.colorScheme.primary.withValues(alpha: 0.12),
        foreground: theme.colorScheme.primary,
      );
    case RouteState.planned:
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
