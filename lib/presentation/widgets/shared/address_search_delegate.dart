import 'package:flutter/material.dart';

import 'package:smart_route_app/infrastructure/mocks/stops_sample.dart';

class AddressSearchDelegate extends SearchDelegate {
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

    final normalizedQuery = query.toLowerCase();
    final matches = stopsSample
        .where((stop) => stop.address.toLowerCase().contains(normalizedQuery))
        .toList();

    if (matches.isEmpty) {
      return emptySearch;
    }

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final stop = matches[index];
        return ListTile(
          leading: const Icon(Icons.place_outlined),
          title: Text(stop.address),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }
}
