{
    description = "Image viewer";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs, ... }:
        let
            supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

            outputsFor = system:
            let
                pkgs = nixpkgs.legacyPackages.${system};
                pname = "aaxview";
                version = "0.0.1";
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
            in {
                devShells.${system}.default = pkgs.mkShell {
                    inherit buildInputs nativeBuildInputs;
                };

                packages.${system}.default = pkgs.stdenv.mkDerivation {
                    inherit buildInputs nativeBuildInputs pname version src;
                };
            };
        in
            nixpkgs.lib.foldl' nixpkgs.lib.recursiveUpdate {} (map outputsFor supportedSystems);
}
