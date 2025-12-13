// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// final permissionsProvider = FutureProvider<bool>((ref) async {
//   final statuses = await [
//     Permission.bluetooth,
//     Permission.bluetoothScan,
//     Permission.bluetoothAdvertise,
//     Permission.bluetoothConnect,
//     Permission.location,
//   ].request();
//
//   return statuses.values.every((status) => status.isGranted);
// });