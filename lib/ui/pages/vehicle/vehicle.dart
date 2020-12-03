import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../repositories/index.dart';
import '../../screens/index.dart';
import 'index.dart';

class VehiclePage extends StatelessWidget {
  final String vehicleId;

  static const route = '/vehicle';

  const VehiclePage({Key key, this.vehicleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (context.watch<VehiclesRepository>().getVehicleType(vehicleId)) {
      case 'rocket':
        return RocketPage(vehicleId);
      case 'capsule':
        return DragonPage(vehicleId);
      case 'ship':
        return ShipPage(vehicleId);
      case 'roadster':
        return RoadsterPage(vehicleId);
      default:
        return ErrorScreen();
    }
  }
}
