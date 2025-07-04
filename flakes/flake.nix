{
  description = "Useful flakes for golang and Kubernetes projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      with nixpkgs.legacyPackages.${system}; rec {
        packages = rec {
          kubectl-kcp = buildGoLatestModule rec {
            name = "kubectl-kcp";
            version = "0.27.1";
            src = fetchFromGitHub {
              owner = "kcp-dev";
              repo = "kcp";
              rev = "v${version}";
              hash = "sha256-X4zSuul/dFvnv3ayrUewngZgt39bxCd2ZxTObR0QY5s=";
            };
            doCheck = false;
            modRoot = "./cli";
            subPackages = [
              "cmd/kubectl-create-workspace"
              "cmd/kubectl-ws"
              "cmd/kubectl-kcp"
            ];
            vendorHash = "sha256-J7D8CkMU0trClW+/kusRJxn1GAbXaJg64ufz9HyZCec=";
          };

          kcp-apigen = buildGoLatestModule rec {
            name = "kcp-apigen";
            version = "0.27.1";
            src = fetchFromGitHub {
              owner = "kcp-dev";
              repo = "kcp";
              rev = "v${version}";
              hash = "sha256-X4zSuul/dFvnv3ayrUewngZgt39bxCd2ZxTObR0QY5s=";
            };
            doCheck = false;
            modRoot = "./sdk";
            subPackages = [
              "cmd/apigen"
            ];
            vendorHash = "sha256-1sLjLhGGHRclEN0otiBTo7mIB0IEWQddwi6BG6/6wTw=";
          };
        };

        formatter = alejandra;
      }
    );
}
