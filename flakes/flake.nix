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
            version = "0.28.1";
            src = fetchFromGitHub {
              owner = "kcp-dev";
              repo = "kcp";
              rev = "v${version}";
              hash = "sha256-GwfrFaGLrfUTxLoacGCHHzJ41+tA7flb4wvjWJntj+g=";
            };
            doCheck = false;
            modRoot = "./cli";
            subPackages = [
              "cmd/kubectl-create-workspace"
              "cmd/kubectl-ws"
              "cmd/kubectl-kcp"
            ];
            vendorHash = "sha256-WBq0Lnr1D2GFQYiXHoTma7Tno/x8qSLIAlqXlEFx0ek=";
          };

          kcp-apigen = buildGoLatestModule rec {
            name = "kcp-apigen";
            version = "0.28.1";
            src = fetchFromGitHub {
              owner = "kcp-dev";
              repo = "kcp";
              rev = "v${version}";
              hash = "sha256-GwfrFaGLrfUTxLoacGCHHzJ41+tA7flb4wvjWJntj+g=";
            };
            doCheck = false;
            modRoot = "./sdk";
            subPackages = [
              "cmd/apigen"
            ];
            vendorHash = "sha256-U6LJc2kYhObO0onGqbbrGwN2Ns2MYsz34+G5ncwahC4=";
          };
        };

        formatter = alejandra;
      }
    );
}
