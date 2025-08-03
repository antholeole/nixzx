pkgs:
pkgs.writeZxApplication {
  name = "multifile";
  runtimeInputs = with pkgs; [hello];
  src = ./.;
  entrypoint = "entry.mts";
}
