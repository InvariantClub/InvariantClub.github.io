{ inputs, ... }:
with inputs; {
  perSystem =
    { lib
    , system
    , ...
    }:
    let
      pkgs = import nixpkgs { inherit system; };
      build = pkgs.buildNpmPackage {
        name = "invariant.club";
        src = ../.;
        version = "0.1.0";

        npmDeps = pkgs.importNpmLock { npmRoot = ../.; };

        npmConfigHook = pkgs.importNpmLock.npmConfigHook;

        nativeBuildInputs = with pkgs; [ git ];

        buildPhase = ''
          runHook preBuild
          npm run build -- 2>&1 | cat
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mv .vitepress/dist $out
          runHook postInstall
        '';
      };
    in
    rec {
      packages.default = build;

      apps.serve = {
        program = pkgs.writeShellApplication {
          name = "serve";
          text = ''
            ${lib.getExe pkgs.simple-http-server} \
              --index \
              ${build.out}
          '';
        };
        type = "app";
      };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nodejs
          simple-http-server
          (aspellWithDicts (d: with d; [ en en-computers ]))
        ];
      };
    };
}
