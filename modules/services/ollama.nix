{ pkgs, ... }:
let
  ollamaPort = 11111;
  ollamaModel = "qwen2.5:3b";
  localhostAddress = "127.0.0.1";
in
{
  environment.variables = {
    OLLAMA_HOST = "${localhostAddress}:${toString ollamaPort}";
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cpu;
    host = localhostAddress;
    port = ollamaPort;

    loadModels = [ ollamaModel ];
  };

}
