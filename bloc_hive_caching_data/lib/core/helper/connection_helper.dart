import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectionHelper {
  // Add methods to check internet connectivity using Dio and connectivity_plus
  Future<bool> checkInternetConnection() async {
    // Implementation for checking internet connection

    final List<ConnectivityResult> connectivityResults = await Connectivity()
        .checkConnectivity();

    if (connectivityResults.contains(ConnectivityResult.none)) {
      return false; // Not connected to any network
    } else if (connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.wifi) ||
        connectivityResults.contains(ConnectivityResult.vpn)) {
      return true; // Connected to a network
    }
    return false; // Fallback case (not connected)
  }
}
