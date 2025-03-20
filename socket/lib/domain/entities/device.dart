// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

class Device {
  String deviceId;
  String deviceType;
  WebSocket? socket;
  Device({
    required this.deviceId,
    required this.deviceType,
    this.socket,
  });

  Device copyWith({
    String? deviceId,
    String? deviceType,
    WebSocket? socket,
  }) {
    return Device(
      deviceId: deviceId ?? this.deviceId,
      deviceType: deviceType ?? this.deviceType,
      socket: socket ?? this.socket,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deviceId': deviceId,
      'deviceType': deviceType,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      deviceId: map['deviceId'] as String,
      deviceType: map['deviceType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) =>
      Device.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Device(deviceId: $deviceId, deviceType: $deviceType, socket: $socket)';

  @override
  bool operator ==(covariant Device other) {
    if (identical(this, other)) return true;

    return other.deviceId == deviceId &&
        other.deviceType == deviceType &&
        other.socket == socket;
  }

  @override
  int get hashCode => deviceId.hashCode ^ deviceType.hashCode ^ socket.hashCode;
}
