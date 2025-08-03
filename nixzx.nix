pkgs: {
  name,
  src,
  runtimeInputs ? [],
  entrypoint ? null,
}: let
  entryIsFile = pkgs.lib.pathIsRegularFile src;

  # Determine if src is a single file or directory
  realEntrypoint =
    if entryIsFile
    then builtins.baseNameOf src
    else
      (
        if entrypoint == null
        then throw "nixzx: if src is a directory, then entrypoint must not be null."
        else entrypoint
      );

  sourceDrv = pkgs.runCommand "make-source-${name}" {} (''
      # create a synthetic node modules.
      mkdir -p $out/lib/node_modules
      cd $out/lib
      ln -s ${pkgs.zx}/lib/node_modules/zx node_modules/zx
    ''
    + (
      if entryIsFile
      then ''
        cp -r ${src} $out/lib/${realEntrypoint}
      ''
      else ''
        cp -r ${src}/* $out/lib/
      ''
    ));
in
  pkgs.writeShellApplication {
    inherit name;

    runtimeInputs =
      runtimeInputs
      ++ [
        sourceDrv
        pkgs.nodejs_24 # 24 for strip types
      ];
    text = ''
      cd ${sourceDrv}/lib
      NODE_OPTIONS=--disable-warning=ExperimentalWarning node ${realEntrypoint} "$@"
    '';
  }
