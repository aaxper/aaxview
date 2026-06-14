{
    description = "Image viewer";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs, ... }:
        let
            supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
            forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
        in {
            packages = forAllSystems (system: {
                default = 
                let 
                    pkgs = nixpkgs.legacyPackages.${system}; 
                in 
                    pkgs.stdenv.mkDerivation {
                        pname = "aaxview";
                        version = "0.2.0";
                        src = ./.;
                        buildInputs = with pkgs; [
                            qt6.qtbase
                            qt6.qtdeclarative
                            qt6.qtimageformats
                        ];
                        nativeBuildInputs = with pkgs; [
                            cmake
                            qt6.qtbase
                            qt6.wrapQtAppsHook
                        ];
                    };
            });
        };
}
