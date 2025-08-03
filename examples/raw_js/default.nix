pkgs:
pkgs.writeZxApplication {
  name = "raw_js";
  runtimeInputs = with pkgs; [hello];
  src = ./js_entrypoint.js;
}
