{ inputs, ... }:
{
  imports = [
    inputs.haskell-flake.flakeModule
  ];
  perSystem = { self', lib, config, pkgs, ... }: {
    packages.dockerImage = pkgs.dockerTools.buildImage {
      name = "pgfried";
      created = "now";
      copyToRoot = pkgs.buildEnv {
        paths = with pkgs; [
          self'.packages.default
        ];
        name = "pgfried";
        pathsToLink = [ "/bin" ];
      };
      config = {
        Cmd = [ "${pkgs.lib.getExe self'.packages.default}" ];
      };
    };

    # Our only Haskell project. You can have multiple projects, but this template
    # has only one.
    # See https://github.com/srid/haskell-flake/blob/master/example/flake.nix
    haskellProjects.default = {
      # To avoid unnecessary rebuilds, we filter projectRoot:
      # https://community.flake.parts/haskell-flake/local#rebuild
      projectRoot = builtins.toString (lib.fileset.toSource {
        root = ../..;
        fileset = lib.fileset.unions [
          ../../src
          ../../pgfried.cabal
          ../../LICENSE
          ../../README.md
        ];
      });

      # The base package set (this value is the default)
      # basePackages = pkgs.haskellPackages;

      # Packages to add on top of `basePackages`
      packages = {
        # Add source or Hackage overrides here
        # (Local packages are added automatically)
        /*
        aeson.source = "1.5.0.0" # Hackage version
        shower.source = inputs.shower; # Flake input
        */
      };

      # Add your package overrides here
      settings = {
        /*
        pgfried = {
          haddock = false;
        };
        aeson = {
          check = false;
        };
        */
      };

      # Development shell configuration
      devShell = {
        hlsCheck.enable = false;
      };

      # What should haskell-flake add to flake outputs?
      autoWire = [ "packages" "apps" "checks" ]; # Wire all but the devShell
    };

    # Default package & app.
    packages.default = self'.packages.pgfried;
    apps.default = self'.apps.pgfried;
  };
}
