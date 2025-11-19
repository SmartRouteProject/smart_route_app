import 'package:smart_route_app/domain/domain.dart';

final List<RouteEnt> sampleRoutes = [
  RouteEnt(
    name: "Ruta 1",
    geometry: 1,
    creationDate: DateTime.now().subtract(Duration(days: 1)),
    state: RouteState.completed,
    returnAddress: ReturnAddress(
      nickname: 'Casa',
      latitude: -34.901112,
      longitude: -56.164532,
      address: 'Bvar. Artigas 1825, Montevideo',
    ),
    stops: [
      DeliveryStop(
        latitude: -34.906676,
        longitude: -56.199212,
        address: 'Av. 8 de Octubre 2738, Montevideo',
      ),
      PickupStop(
        latitude: -34.888214,
        longitude: -56.161758,
        address: 'Plaza Independencia, Montevideo',
      ),
    ],
  ),

  RouteEnt(
    name: "Ruta 2",
    geometry: 2,
    creationDate: DateTime.now().subtract(Duration(days: 2)),
    state: RouteState.started,
    returnAddress: ReturnAddress(
      nickname: 'Depósito',
      latitude: -34.841389,
      longitude: -56.219444,
      address: 'Av. Luis Alberto de Herrera 3367, Montevideo',
    ),
    stops: [
      DeliveryStop(
        latitude: -34.859572,
        longitude: -56.230245,
        address: 'Montevideo Shopping, Montevideo',
      ),
      DeliveryStop(
        latitude: -34.866598,
        longitude: -56.203892,
        address: '3 Cruces Terminal, Montevideo',
      ),
      PickupStop(
        latitude: -34.818364,
        longitude: -56.185376,
        address: 'Portones Shopping, Montevideo',
      ),
    ],
  ),

  RouteEnt(
    name: "Ruta 3",
    geometry: 3,
    creationDate: DateTime.now().subtract(Duration(days: 3)),
    state: RouteState.planned,
    returnAddress: ReturnAddress(
      nickname: 'Oficina',
      latitude: -34.902310,
      longitude: -56.168130,
      address: 'Ciudad Vieja, Montevideo',
    ),
    stops: [
      PickupStop(
        latitude: -34.903944,
        longitude: -56.190036,
        address: 'Tribunal de Cuentas, Montevideo',
      ),
      DeliveryStop(
        latitude: -34.893047,
        longitude: -56.165505,
        address: 'INGAVI Aduana, Montevideo',
      ),
    ],
  ),

  RouteEnt(
    name: "Ruta 4",
    geometry: 4,
    creationDate: DateTime.now().subtract(Duration(days: 5)),
    state: RouteState.completed,
    returnAddress: ReturnAddress(
      nickname: 'Local Canelones',
      latitude: -34.537222,
      longitude: -56.280556,
      address: 'Av. Wilson Ferreira Aldunate, Canelones',
    ),
    stops: [
      DeliveryStop(
        latitude: -34.640042,
        longitude: -56.072201,
        address: 'Las Piedras Shopping, Las Piedras',
      ),
      PickupStop(
        latitude: -34.622650,
        longitude: -56.358902,
        address: 'Santa Lucía, Canelones',
      ),
      DeliveryStop(
        latitude: -34.669102,
        longitude: -56.226580,
        address: 'Progreso, Canelones',
      ),
    ],
  ),

  RouteEnt(
    name: "Ruta 5",
    geometry: 5,
    creationDate: DateTime.now().subtract(Duration(days: 7)),
    state: RouteState.started,
    returnAddress: ReturnAddress(
      nickname: 'Galpón Centro',
      latitude: -34.904115,
      longitude: -56.188843,
      address: 'Av. Uruguay 1290, Montevideo',
    ),
    stops: [
      DeliveryStop(
        latitude: -34.896201,
        longitude: -56.130789,
        address: 'Pocitos, Montevideo',
      ),
      PickupStop(
        latitude: -34.927090,
        longitude: -56.164345,
        address: 'Parque Rodó, Montevideo',
      ),
      DeliveryStop(
        latitude: -34.884735,
        longitude: -56.078427,
        address: 'Carrasco, Montevideo',
      ),
    ],
  ),
];
