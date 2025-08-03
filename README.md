# nixzx

a simple wrapper to be able to run [zx](https://github.com/google/zx) scripts.

## Using

first, add it as an overlay:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixzx = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:antholeole/nixzx";
    }
  };

  outputs = { nixpkgs, nixzx, ... }: let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixzx.overlays.default ];
      };
  in {
    # do stuff with pkgs...
  };
}
```

then, write a zx script:

```ts
import { $ } from "zx";

await $`cat package.json | grep name`

const branch = await $`git branch --show-current`
await $`dep deploy --branch=${branch}`
```

finally, use it in a derivation:

```nix
{pkgs,...}: {
  environment.systemPackages = [

    # single file scripts...
    (pkgs.writeZxApplication {
      name = "first-zx-script";
      runtimeInputs = with pkgs; [ git ];
      # if src is only one file, entrypoint is inferred.
      src = ./script.mts;
    })

    # or multi-file scripts.
    (pkgs.writeZxApplication {
      name = "other-zx-script";
      runtimeInputs = with pkgs; [ git ];

      src = ./.;
      entrypoint = "entry.mts";
    })
  ];
}
```

## IDE support

to get ide support, run `npm i google/zx` in the root of your project. Unfortunately, there's no way to tell LSP's that you're writing a global script so we trick the IDE into thinking we're using zx from your new `package.json`. You may `.gitignore` it or check it in, it does not matter.

## out of scope

- `nixzx` does not allow you to add other npm packages (prs welcome).
- non-`mts` extensions.
