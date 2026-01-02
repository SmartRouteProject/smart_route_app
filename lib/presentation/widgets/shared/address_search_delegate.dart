import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_route_app/domain/domain.dart';

import 'package:smart_route_app/infrastructure/infrastructure.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';

class AddressSearchDelegate extends SearchDelegate<String?> {
  final ValueChanged<String>? onSelectedAddress;
  final ValueChanged<AddressSearch>? onSelectedResult;
  final IMapsRepository _mapsRepository;
  Timer? _debounce;
  final ValueNotifier<_AddressSearchState> _stateNotifier = ValueNotifier(
    _AddressSearchState.initial(),
  );
  String _lastQuery = '';

  AddressSearchDelegate({
    this.onSelectedAddress,
    this.onSelectedResult,
    IMapsRepository? mapsRepository,
  }) : _mapsRepository = mapsRepository ?? MapsRepositoryImpl();

  void _onQueryChanged(String value) {
    if (value == _lastQuery) return;
    _lastQuery = value;
    _debounce?.cancel();
    _stateNotifier.value = _stateNotifier.value.copyWith(isLoading: true);
    _debounce = Timer(const Duration(seconds: 1), () async {
      try {
        final results = await _mapsRepository.findPlace(value);
        _stateNotifier.value = _stateNotifier.value.copyWith(
          isLoading: false,
          results: results,
        );
      } catch (_) {
        _stateNotifier.value = _stateNotifier.value.copyWith(
          isLoading: false,
          results: const [],
        );
      }
    });
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final emptySearch = Center(
      child: Icon(Icons.add_location_alt, color: Colors.black38, size: 100),
    );

    if (query.isEmpty) {
      return emptySearch;
    }

    _onQueryChanged(query);

    return ValueListenableBuilder<_AddressSearchState>(
      valueListenable: _stateNotifier,
      builder: (context, state, _) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.results.isEmpty) {
          return emptySearch;
        }

        return ListView.builder(
          itemCount: state.results.length,
          itemBuilder: (context, index) {
            final result = state.results[index];
            return ListTile(
              leading: const Icon(Icons.place_outlined),
              title: Text(result.displayName),
              subtitle: Text(result.formattedAddress),
              onTap: () {
                if (onSelectedResult != null) {
                  onSelectedResult!(result);
                  close(context, result.formattedAddress);
                  return;
                }
                if (onSelectedAddress != null) {
                  onSelectedAddress!(result.formattedAddress);
                  close(context, result.formattedAddress);
                  return;
                }

                final navigator = Navigator.of(context, rootNavigator: true);
                close(context, null);
                Future.microtask(() {
                  navigator.push(
                    MaterialPageRoute(
                      builder: (_) => StopDetailPage(
                        stop: PickupStop(
                          latitude: result.latitude,
                          longitude: result.longitude,
                          address: result.formattedAddress,
                        ),
                      ),
                    ),
                  );
                });
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  void close(BuildContext context, String? result) {
    _debounce?.cancel();
    _stateNotifier.dispose();
    super.close(context, result);
  }
}

class _AddressSearchState {
  final bool isLoading;
  final List<AddressSearch> results;

  const _AddressSearchState({required this.isLoading, required this.results});

  factory _AddressSearchState.initial() {
    return const _AddressSearchState(isLoading: false, results: []);
  }

  _AddressSearchState copyWith({
    bool? isLoading,
    List<AddressSearch>? results,
  }) {
    return _AddressSearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
    );
  }
}
