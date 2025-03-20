import 'lib/domain/usecases/gerenciar_devices.dart';
import 'lib/infra/socket/socket_server.dart';

void main(List<String> args) {
  final GerenciarDevices gerenciarDevices = GerenciarDevices();
  SocketServer server = SocketServer(
      wsPort: 8089, gerenciarDevices: gerenciarDevices, httpPort: 8080);
  server.init();
}
