import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectionHelper {
  // Add methods to check internet connectivity using Dio and connectivity_plus
  Future<bool> checkInternetConnection() async {
    // Implementation for checking internet connection
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false; // Not connected to any network
    } else if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.vpn) {
      return true; // Connected to a network
    }
    return false; // Fallback case (not connected)
  }
}
