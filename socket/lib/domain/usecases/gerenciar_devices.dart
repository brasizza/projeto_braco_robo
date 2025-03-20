import '../entities/device.dart';

class GerenciarDevices {
  final Map<String, Device> _devices = {};

  void cadastrarDevice(Device device) {
    if (!_devices.containsKey(device.deviceId)) {
      _devices[device.deviceId] = device;
    }
  }

  void removeDevice(String deviceId) {
    if (_devices.containsKey(deviceId)) {
      _devices[deviceId]?.socket?.close();
      _devices.remove(deviceId);
    }
  }

//mandarMensagem (Device){}
  List<Device> mostrarDevices() => _devices.values.toList();
}
