import 'dart:convert';
import 'dart:io';

import '../../domain/entities/device.dart';
import '../../domain/usecases/gerenciar_devices.dart';

class SocketServer {
  final int _wsPort;
  final int _httpPort;
  HttpServer? _server;
  GerenciarDevices gerenciarDevices;

  SocketServer(
      {required int wsPort,
      required this.gerenciarDevices,
      required int httpPort})
      : _wsPort = wsPort,
        _httpPort = httpPort;

  void gerenciarHttp(HttpRequest request) {
    if (request.uri.path == '/devices') {
      request.response
        ..headers.contentType = ContentType.json
        ..statusCode = HttpStatus.ok
        ..write(json.encode({
          'devices':
              gerenciarDevices.mostrarDevices().map((d) => d.toMap()).toList()
        }))
        ..close();
    }
  }

  Future<void> init() async {
    _server = await HttpServer.bind(
      InternetAddress.anyIPv4,
      _wsPort,
    );
    final httpServer =
        await HttpServer.bind(InternetAddress.anyIPv4, _httpPort);
    httpServer.listen(gerenciarHttp);
    print("Socket rodando em ws://${_server!.address.address}:$_wsPort");
    await for (var request in _server!) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        await _pegarRequequisicao(request);
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..write("Acesso a este server somente via socket");
        request.response.close();
      }
    }
  }

  Future<void> _pegarRequequisicao(HttpRequest request) async {
    WebSocket socket = await WebSocketTransformer.upgrade(
      request,
    );

    socket.pingInterval = Duration(seconds: 5);
    String? deviceId = request.headers.value('deviceID');
    String? deviceType = request.headers.value('deviceType');
    if (deviceId == null || deviceType == null) {
      socket.close(WebSocketStatus.goingAway);
    } else {
      var device = Device(deviceId: deviceId, deviceType: deviceType);
      gerenciarDevices.cadastrarDevice(device);
      print(
        "Socket foi conectado, bem vindo:  $deviceId",
      );
      socket.listen((mensagem) {
        print("Mensagem do socket  $mensagem");
      }, onError: (erro) {
        print("Erro ao se conectar $erro");
        gerenciarDevices.removeDevice(deviceId);
      }, onDone: () {
        print("Socket foi desconectado");
        gerenciarDevices.removeDevice(deviceId);
      });
    }
  }
}
