#include <WebSocketsClient.h>
#include "MinhaConexao.h"
WebSocketsClient webSocket;
const char *WS_SERVER = "192.168.5.59";
const uint16_t WS_PORT = 8089;
MinhaConexao minhaConexao(WIFI_SSID, WIFI_PASSWORD);

void setup() {
  Serial.begin(115200);
  minhaConexao.conectar();
  webSocket.begin(WS_SERVER, WS_PORT);
  webSocket.setReconnectInterval(5000);
}

void loop() {
  minhaConexao.checaConexao();
  webSocket.loop();
}
