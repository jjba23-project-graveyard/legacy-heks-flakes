# heks-flakes

# Copyright © Josep Bigorra <jjbigorra@gmail.com>

# heks-flakes is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# heks-flakes is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with heks-flakes.  If not, see <https://www.gnu.org/licenses/>.
{
  description = "A flake.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        commonPackages = with pkgs;
          [ python313 uv zlib git curl wget cmake ]
          ++ (with pkgs; [ gcc stdenv.cc.cc.lib ]);

        runScript = pkgs.writeShellScriptBin "run-script" ''
          #!/usr/bin/env bash
          source .venv/bin/activate
        '';

        baseEnvSetup = pkgs: ''
          # Set up the Python virtual environment with uv
          test -d .venv || ${pkgs.uv}/bin/uv venv .venv
          export VIRTUAL_ENV="$(pwd)/.venv"
          export PATH="$VIRTUAL_ENV/bin:$PATH"
          export LD_LIBRARY_PATH=${
            pkgs.lib.makeLibraryPath commonPackages
          }:$LD_LIBRARY_PATH
        '';

        mkLinuxShells = pkgs: {
          default = pkgs.mkShell {
            buildInputs = commonPackages;
            shellHook = ''
              ${baseEnvSetup pkgs}
              # Run the full interactive script
              ${runScript}/bin/run-script
            '';
          };
        };
        shells = mkLinuxShells pkgs;
      in {
        devShells = shells;
        devShell = shells.default;
      });
}

