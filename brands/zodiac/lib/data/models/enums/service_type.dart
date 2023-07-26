enum ServiceType {
  online,
  offline;

  static ServiceType fromInt(int value) {
    switch (value) {
      case 0:
        return ServiceType.offline;
      case 1:
        return ServiceType.online;
      default:
        return ServiceType.offline;
    }
  }

  int get toInt {
    switch (this) {
      case ServiceType.offline:
        return 0;
      case ServiceType.online:
        return 1;
    }
  }
}
