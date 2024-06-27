import 'package:service_providers_glow/models/activeServiceProviders.dart';

class GeofireAssistant {
  static List<ActiveServiceProviders> activeServiceProviderList = [];

  // static get activeServiceProviderList => null;

  static void deletedOfflineDriverFromList(String serviceId) {
    int indexNumber = activeServiceProviderList
        .indexWhere((element) => element.serviceId == serviceId);

    activeServiceProviderList.remove(indexNumber);
  }

  static void updateActiveDriverLocation(
      ActiveServiceProviders serviceProviderOnMove) {
    int indexNumber = activeServiceProviderList.indexWhere(
        (element) => element.serviceId == serviceProviderOnMove.serviceId);

    activeServiceProviderList[indexNumber].locationLatitude =
        serviceProviderOnMove.locationLatitude;

    activeServiceProviderList[indexNumber].locationLongitude =
        serviceProviderOnMove.locationLongitude;
  }

  static void updateActiveLocation(
      ActiveServiceProviders activeServiceProviders) {}
}
