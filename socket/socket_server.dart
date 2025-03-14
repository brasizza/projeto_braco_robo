import 'dart:io';

class SocketServer {
  final int _wsPort;
  HttpServer? _server;

  SocketServer({required int wsPort}) : _wsPort = wsPort;

  Future<void> init() async {
    _server = await HttpServer.bind(
      InternetAddress.anyIPv4,
      _wsPort,
    );
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
    String? deviceId = request.headers.value('deviceID');
    print(
      "Socket foi conectado, bem vindo:  $deviceId",
    );
    socket.listen((mensagem) {
      print("Mensagem do socket  $mensagem");
    }, onError: (erro) {
      print("Erro ao se conectar $erro");
    }, onDone: () {
      print("Socket foi desconectado");
    });
  }
}

void main(List<String> args) {
  SocketServer server = SocketServer(wsPort: 8089);
  server.init();
}
