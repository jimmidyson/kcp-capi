# KCP CAPI Demo

This project demonstrates the integration of [Cluster API (CAPI)](https://cluster-api.sigs.k8s.io/) with [KCP](https://kcp.io/), showcasing how Kubernetes cluster management APIs can be virtualized and consumed across multiple workspaces.

## Overview

The project sets up a complete demonstration environment that includes:

- A local Kubernetes cluster (Kind) as the infrastructure
- KCP for API virtualization and workspace management
- Cluster API resources exported as virtualized APIs
- Certificate management with cert-manager
- Network policies with Cilium
- Resource reflection between workspaces

## Prerequisites

This project uses [Devbox](https://www.jetify.com/devbox) for dependency management. Ensure you have Devbox installed on your system.

### Required Tools

The following tools are automatically managed via Devbox:

- **crane** - Container image manipulation
- **envsubst** - Environment variable substitution
- **go-task** - Task runner
- **kind** - Kubernetes in Docker
- **kubectl** - Kubernetes CLI
- **helm** - Kubernetes package manager
- **kustomize** - Kubernetes configuration management
- **yq** - YAML processor
- **kcp-apigen** - KCP API export generator (custom flake)
- **kubectl-kcp** - KCP kubectl plugin (custom flake)

## Quick Start

1. **Initialize the development environment:**

   ```bash
   devbox shell
   ```

2. **Run the complete demo:**

   ```bash
   task run-demo
   ```

   This command will:
   - Create a Kind cluster
   - Deploy cert-manager for certificate management
   - Deploy reflector for cross-namespace resource synchronization
   - Deploy KCP with virtualized workspaces
   - Generate CAPI API exports
   - Create CAPI API provider workspace
   - Create CAPI API consumer workspace

3. **Access KCP:**

   After deployment, you can access KCP using the generated kubeconfig:

   ```bash
   export KUBECONFIG=kcp-admin.kubeconfig
   kubectl ws
   ```

## Project Structure

```text
├── devbox.json              # Devbox dependency configuration
├── Taskfile.yaml           # Main task definitions
├── config/                  # Configuration files
│   ├── cert-manager-values.yaml
│   ├── cilium-values.yaml
│   ├── kcp-values.yaml
│   ├── kind-config.yaml
│   └── apis/capi/          # CAPI API definitions
│       ├── crds/           # Custom Resource Definitions
│       └── exports/        # Generated API exports
├── tasks/                   # Task definitions
│   ├── apis.yaml           # API generation tasks
│   ├── cert-manager.yaml   # Certificate manager tasks
│   ├── kcp.yaml            # KCP deployment tasks
│   ├── kind.yaml           # Kind cluster tasks
│   └── reflector.yaml      # Reflector deployment tasks
└── flakes/                 # Nix flakes for custom tools
    ├── flake.nix
    └── flake.lock
```

## Available Tasks

### Main Tasks

- `task run-demo` - Run the complete demo setup
- `task cleanup` - Clean up the demo environment

### Component-specific Tasks

- `task kind:create` - Create Kind cluster
- `task kind:delete` - Delete Kind cluster
- `task cert-manager:deploy` - Deploy cert-manager
- `task reflector:deploy` - Deploy reflector
- `task kcp:deploy` - Deploy KCP
- `task apis:capi-apigen` - Generate CAPI API exports

## Configuration

### KCP Configuration

The KCP deployment is configured via `config/kcp-values.yaml`:

- **External Access**: Available at `kcp.127.0.0.1.sslip.io:8443`
- **Authentication**: Token-based authentication enabled
- **Workspaces**: Home workspaces enabled for user isolation
- **Gateway**: Cilium gateway for ingress traffic

### Kind Configuration

The Kind cluster is configured with:

- Custom networking for KCP integration
- Port forwarding for external access
- Volume mounts for persistent storage

## Workspaces

The demo creates two main workspaces:

1. **capi-api-provider**: Contains the CAPI API exports and serves as the provider of cluster management APIs
2. **capi-api-consumer**: Consumes the virtualized CAPI APIs for cluster operations

## API Exports

The project generates KCP API exports for the following Cluster API resources:

- **Core APIs** (`cluster.x-k8s.io`):
  - Cluster, ClusterClass
  - Machine, MachineDeployment, MachineSet, MachinePool
  - MachineHealthCheck, MachineDrainRule

- **Addon APIs** (`addons.cluster.x-k8s.io`):
  - ClusterResourceSet, ClusterResourceSetBinding

- **IPAM APIs** (`ipam.cluster.x-k8s.io`):
  - IPAddress, IPAddressClaim

- **Runtime APIs** (`runtime.cluster.x-k8s.io`):
  - ExtensionConfig

## Development

### Adding New APIs

To add new APIs to the virtualization:

1. Update the kustomize build in `tasks/apis.yaml` to include your CRDs
2. Run `task apis:capi-apigen` to regenerate exports
3. Apply the new exports to the provider workspace

### Customizing KCP

Modify `config/kcp-values.yaml` to adjust:

- External hostnames and ports
- Resource requirements
- Authentication methods
- Gateway configuration

## Troubleshooting

### Common Issues

1. **Kind cluster fails to start**: Ensure Docker is running and you have sufficient resources
2. **KCP not accessible**: Check that the port forwarding is working and certificates are valid
3. **API exports not working**: Verify that the CAPI CRDs are properly installed and apigen completed successfully

### Logs and Debugging

- Check Kind cluster status: `kubectl cluster-info --context kind-kcp-capi-kind`
- View KCP logs: `kubectl logs -n kcp -l app.kubernetes.io/name=kcp`
- Check workspace status: `kubectl ws` (with KCP kubeconfig)

## Cleanup

To completely clean up the demo environment:

```bash
task cleanup
```

This will delete the Kind cluster and all associated resources.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `task run-demo`
5. Submit a pull request

## License

This project is provided as-is for demonstration purposes. Please refer to the individual component licenses for specific terms.

## Resources

- [KCP Documentation](https://docs.kcp.io/)
- [Cluster API Documentation](https://cluster-api.sigs.k8s.io/)
- [Kind Documentation](https://kind.sigs.k8s.io/)
- [Devbox Documentation](https://www.jetify.com/devbox/docs/)
