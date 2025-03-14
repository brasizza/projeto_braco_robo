#include <WiFi.h>
#include "Secrets.h"
class MinhaConexao {
private:
  const char* _ssid;
  const char* _password;

public:
  MinhaConexao(const char* ssid, const char* password) {
    _ssid = ssid;
    _password = password;
  }

  void conectar() {
    Serial.print("Iniciando a conexao em:");
    Serial.println(_ssid);
    WiFi.begin(_ssid, _password);
    delay(2000);
    Serial.print("Status da conexao: ");
    Serial.println(WiFi.status());
    if (WiFi.status() == 3) {
      Serial.print("Seu IP: ");
      Serial.println(WiFi.localIP());
      Serial.print("Seu Mac: ");
      Serial.println(WiFi.macAddress());
    }
  }
  void checaConexao() {
    if (WiFi.status() != 3) {
      Serial.println("Conexao do wifi perdida!");
      WiFi.disconnect();
      conectar();
    }
  }
};


