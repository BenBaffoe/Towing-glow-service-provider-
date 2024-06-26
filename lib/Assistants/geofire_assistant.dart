import 'package:service_providers_glow/models/activeServiceProviders.dart';

class GeofireAssistant {
  static List<ActiveServiceProviders> activeDriversList = [];

  static get activeServiceProviderList => null;

  static void deletedOfflineDriverFromList(String serviceId) {
    int indexNumber = activeDriversList
        .indexWhere((element) => element.serviceId == serviceId);

    activeDriversList.remove(indexNumber);
  }

  static void updateActiveDriverLocation(
      ActiveServiceProviders serviceProviderOnMove) {
    int indexNumber = activeDriversList.indexWhere(
        (element) => element.serviceId == serviceProviderOnMove.serviceId);

    activeServiceProviderList[indexNumber].locationLatitude =
        serviceProviderOnMove.locationLatitude;

    activeServiceProviderList[indexNumber].locationLongitude =
        serviceProviderOnMove.locationLongitude;
  }

  static void updateActiveLocation(
      ActiveServiceProviders activeServiceProviders) {}
}
