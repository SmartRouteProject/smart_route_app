import 'package:smart_route_app/domain/domain.dart';

final List<Stop> stopsSample = [
  DeliveryStop(
    latitude: -34.901112,
    longitude: -56.164532,
    address: "Av. 18 de Julio 1234, Montevideo",
    status: StopStatus.pending,
  ),
  PickupStop(
    latitude: -34.907450,
    longitude: -56.199000,
    address: "Terminal Tres Cruces, Montevideo",
    status: StopStatus.succeeded,
  ),
  DeliveryStop(
    latitude: -34.891300,
    longitude: -56.187220,
    address: "Ciudad Vieja, Pérez Castellano 1521, Montevideo",
    status: StopStatus.failed,
  ),
  PickupStop(
    latitude: -34.882001,
    longitude: -56.164901,
    address: "Montevideo Shopping, Luis A. de Herrera 1290",
    status: StopStatus.pending,
  ),
  DeliveryStop(
    latitude: -34.871250,
    longitude: -56.148900,
    address: "Costa Urbana Shopping, Canelones",
    status: StopStatus.pending,
  ),
  PickupStop(
    latitude: -34.833001,
    longitude: -56.028500,
    address: "Punta Carretas Shopping, José Ellauri 350",
    status: StopStatus.succeeded,
  ),
  DeliveryStop(
    latitude: -34.903900,
    longitude: -56.163200,
    address: "Palacio Salvo, Plaza Independencia 848, Montevideo",
    status: StopStatus.pending,
  ),
  PickupStop(
    latitude: -34.905650,
    longitude: -56.206220,
    address: "Parque Rodó, Montevideo",
    status: StopStatus.failed,
  ),
  DeliveryStop(
    latitude: -34.784400,
    longitude: -55.981300,
    address: "Carrasco, Av. Alfredo Arocena 1600",
    status: StopStatus.pending,
  ),
  PickupStop(
    latitude: -34.760800,
    longitude: -56.223200,
    address: "Las Piedras Shopping, Gral. Flores 652",
    status: StopStatus.succeeded,
  ),
];
