{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
      systems = import inputs.systems;
      perSystem = { pkgs, lib, self', ... }: let
        pythonVersion = "3.13";
        pythonPkgs = pkgs."python${builtins.replaceStrings [ "." ] [ "" ] pythonVersion}Packages";
      in {
        # version in nixpkgs is outdated, have to override
        packages.beautifulsoup4 = pythonPkgs.beautifulsoup4.overrideAttrs (finalAttrs: previousAttrs: let
          version = "4.13.5";
        in {
          inherit version;
          src = pkgs.fetchPypi {
            inherit version;
            inherit (previousAttrs) pname;
            hash = "sha256-XnATE4KTDnw94zRQovVKY9XksZOG6rQ6WzTVlCaPNpU=";
          };
          patches = [];
        });

        packages.excalidraw-renderer = pkgs.buildNpmPackage rec {
          pname = "excalidraw-renderer";
          version = "0.5.1";

          npmDepsHash = "sha256-m8Bvm2E/i61PKlTGwIis7BgsvTQhMAkkb0ZiKT0L2Y0=";

          src = pkgs.fetchFromGitHub {
            repo = "mkdocs-excalidraw";
            owner = "qdeli187";
            rev = "main";
            hash = "sha256-25ABUjgRf+uoSUWhhL6kCAb6YgGHS1vAYbpTrE8FkV8=";
          };

          sourceRoot = "${src.name}/excalidraw-renderer";

          nativeBuildInputs = with pkgs; [
            mkdocs
            gnumake
            self'.packages.beautifulsoup4
            nodejs
            esbuild
          ];

          buildPhase = ''
            make -C ../ build-prod
            mkdir -p $out
            cp dist/* $out/
            '';

          meta = with lib; {
            description = "Module for importing excalidraw diagrams";
            longDescription = ''
✨ A simple mkdocs plugin to easily embed your excalidraw drawings into your docs 
            '';
            homepage = "https://github.com/qdeli187/mkdocs-excalidraw/";
            changelog = "https://github.com/qdeli187/mkdocs-excalidraw/releases/tag/v${version}";
            license = licenses.asl20;
          };
        };

        packages.mkdocs-excalidraw = pythonPkgs.buildPythonApplication rec {
          pname = "mkdocs-excalidraw";
          version = "0.5.1";
          pyproject = true;

          src = pythonPkgs.fetchPypi {
            pname = "mkdocs_excalidraw";
            inherit version;
            hash = "sha256-N+ScVSDM87bnsGhN+WnBcqEw7mLmFZEN98+CNIl6etw=";
          };

          build-system = with pythonPkgs; [
            poetry-core
          ];

          dependencies = [
            self'.packages.beautifulsoup4
            pkgs.mkdocs
          ];

          pythonImportsCheck = [
            "mkdocs_excalidraw"
          ];

          postInstall = ''
            assets=$out/lib/python3.13/site-packages/mkdocs_excalidraw/assets
            mkdir -p $assets
            jsfile=excalidraw-renderer.bundle.js
            ln -s ${self'.packages.excalidraw-renderer}/$jsfile $assets/$jsfile 
            '';

          meta = {
            description = "Module for importing excalidraw diagrams";
            longDescription = ''
✨ A simple mkdocs plugin to easily embed your excalidraw drawings into your docs 
            '';
            homepage = "https://github.com/qdeli187/mkdocs-excalidraw/";
            changelog = "https://github.com/qdeli187/mkdocs-excalidraw/releases/tag/v${version}";
            license = lib.licenses.asl20;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            mkdocs
            python313Packages.mkdocs-material
            self'.packages.mkdocs-excalidraw
          ];
        };
      };
    });
}
