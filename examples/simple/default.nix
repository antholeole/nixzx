pkgs:
pkgs.writeZxApplication {
  name = "simple";
  runtimeInputs = with pkgs; [hello];
  # if src is only one file, entrypoint is inferred.
  src = ./script.mts;
}
