#include <WebSocketsClient.h>
#include "MinhaConexao.h"
WebSocketsClient websocket;
const char *SOCKET_HOST="192.168.5.58";
const uint16_t SOCKET_PORT=8089;
MinhaConexao minhaConexao(WIFI_SSID, WIFI_PASSWORD);

void setup() {
  Serial.begin(115200);
  minhaConexao.conectar();
  delay(2000);
  websocket.begin(SOCKET_HOST,SOCKET_PORT);
  String headerDeviceId = "deviceID: " + minhaConexao.deviceID;
  websocket.setExtraHeaders(headerDeviceId.c_str());
  websocket.setReconnectInterval(5000);
  websocket.enableHeartbeat(5000, 3000, 2);
}

void loop() {
  minhaConexao.checaConexao();
  websocket.loop();
}
