import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smart_route_app/domain/domain.dart';
import 'package:smart_route_app/presentation/providers/providers.dart';
import 'package:smart_route_app/presentation/screens/screens.dart';
import 'package:smart_route_app/presentation/widgets/returnAdress/return_address_list.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const name = 'home-screen';

  final String? sharedRouteId;

  const HomeScreen({super.key, this.sharedRouteId});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Draggable persistent bottom sheet height state
  double? _sheetHeight;
  static const double _minSheetHeight = 150;
  static const double _initialSheetHeight = 140;

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final sharedRouteId = widget.sharedRouteId;
    if (sharedRouteId != null && sharedRouteId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final acceptedRoute = await ref
            .read(shareRouteProvider.notifier)
            .acceptSharedRoute(sharedRouteId);
        if (!mounted || acceptedRoute != null) return;
        final error = ref.read(shareRouteProvider).errorMessage;
        if (error.isNotEmpty) {
          _showSnackbar(context, error);
          ref.read(shareRouteProvider.notifier).clearError();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(stopFormErrorProvider, (previous, next) {
      if (next.isEmpty) return;
      _showSnackbar(context, next);
      final selectedStop = ref.read(mapProvider).selectedStop;
      if (selectedStop == null) return;
      ref.read(stopFormProvider(selectedStop).notifier).clearError();
    });
    ref.listen<String>(mapErrorProvider, (previous, next) {
      if (next.isEmpty) return;
      _showSnackbar(context, next);
      ref.read(mapProvider.notifier).clearError();
    });
    ref.listen<OptimizationState>(optimizationProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      _showSnackbar(context, next.errorMessage);
      ref.read(optimizationProvider.notifier).clearError();
    });
    ref.listen<ReturnAddressFormState>(returnAddressFormProvider, (
      previous,
      next,
    ) {
      if (next.errorMessage.isEmpty) return;
      _showSnackbar(context, next.errorMessage);
      ref.read(returnAddressFormProvider.notifier).clearError();
    });
    ref.listen<ReportFormState>(reportFormProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      _showSnackbar(context, next.errorMessage);
      ref.read(reportFormProvider.notifier).clearError();
    });

    final mapState = ref.watch(mapProvider);
    final shareRouteState = ref.watch(shareRouteProvider);
    final size = MediaQuery.of(context).size;
    final maxSheetHeight = size.height * 0.6;
    _sheetHeight ??= _initialSheetHeight.clamp(_minSheetHeight, maxSheetHeight);
    final selectedRoute = mapState.selectedRoute;
    final routeState = mapState.selectedRoute?.state;

    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa"),
        actions: [
          IconButton(
            icon: Icon(Icons.assessment_outlined),
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (_) => const GenerateReportDialog(),
              );
            },
            tooltip: 'Generar reportes',
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              showGeneralDialog(
                context: context,
                barrierColor: Colors.black54,
                barrierDismissible: true,
                barrierLabel: 'close-return-adress-list',
                transitionDuration: const Duration(milliseconds: 250),
                pageBuilder: (_, __, ___) {
                  return ReturnAdressList();
                },
              );
            },
            tooltip: 'Dirección de retorno',
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => ConfirmationDialog(
                  title: 'Cerrar sesi\u00f3n',
                  description:
                      '\u00bfEst\u00e1s seguro que deseas cerrar sesi\u00f3n?',
                  onConfirmed: () {},
                ),
              );
              if (confirmed != true) return;

              final logoutResp = await ref.read(authProvider.notifier).logout();
              if (logoutResp) {
                // ignore: use_build_context_synchronously
                context.pushReplacementNamed(LoginScreen.name);
              }
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      drawer: CustomSideMenu(),

      body: Stack(
        children: [
          // MAPA
          const CustomGoogleMap(),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedRoute != null)
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        final next =
                            (_sheetHeight ?? _initialSheetHeight) -
                            details.delta.dy;
                        final maxSheetHeight =
                            MediaQuery.of(context).size.height * 0.6;
                        _sheetHeight = next.clamp(
                          _minSheetHeight,
                          maxSheetHeight,
                        );
                      });
                    },
                    child: RouteBottomSheet(
                      height: (_sheetHeight ?? _initialSheetHeight),
                    ),
                  ),
                if (selectedRoute == null)
                  SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: LoadingFloatingActionButton(
                          label: "Nueva Ruta",
                          loader: false,
                          onPressed: () {
                            showGeneralDialog(
                              context: context,
                              barrierColor: Colors.black54,
                              barrierDismissible: true,
                              barrierLabel: 'close-route-form',
                              transitionDuration: const Duration(
                                milliseconds: 250,
                              ),
                              pageBuilder: (_, __, ___) {
                                return const CreateRoute();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                if (selectedRoute != null && routeState != RouteState.completed)
                  SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: BoxBorder.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        spacing: 5,
                        children: [
                          if (routeState == RouteState.planned)
                            SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: LoadingFloatingActionButton(
                                label: "Iniciar Ruta",
                                loader: false,
                                onPressed: () async {
                                  await ref
                                      .read(mapProvider.notifier)
                                      .startSelectedRoute();
                                },
                              ),
                            ),
                          if (routeState == RouteState.planned)
                            SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: LoadingFloatingActionButton(
                                label: "Optimizar",
                                loader: false,
                                onPressed: () {
                                  showDialog<bool>(
                                    context: context,
                                    builder: (_) => const OptimizationDialog(),
                                  );
                                },
                              ),
                            ),
                          if (routeState == RouteState.started)
                            SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: LoadingFloatingActionButton(
                                label: "Finalizar Ruta",
                                loader: false,
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => ConfirmationDialog(
                                      title: 'Finalizar ruta',
                                      description:
                                          '¿Estás seguro que desea finalizar la ruta?',
                                      onConfirmed: () {},
                                    ),
                                  );
                                  if (confirmed != true) return;

                                  await ref
                                      .read(mapProvider.notifier)
                                      .completeSelectedRoute();
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (shareRouteState.isAccepting) ...[
            const ModalBarrier(dismissible: false, color: Colors.black26),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
