## Project Overview

This is a performance testing repository for Claude Code with Google Vertex AI. It demonstrates and reproduces slow connection issues when Claude Code attempts to connect to Google's metadata server (169.254.169.254:80) during Vertex AI authentication.

## Build and Run Commands

- `make build` - Build the Docker container with Claude Code CLI and Google Cloud SDK
- `make run` - Run the performance test container interactively with network debugging capabilities
- `make clean` - Remove the Docker image
- `make help` - Show available targets and customization options

### Basic Usage
```bash
make build run
```

### Custom Project ID
```bash
# Using environment variable
VERTEX_PROJECT_ID=your-project-id make build run

# Using make variable
make build run VERTEX_PROJECT_ID=your-project-id
```

### Skip Authentication Steps
For testing or when authentication is already configured:
```bash
# Skip gcloud auth login step
make run SKIP_GCLOUD_AUTH_LOGIN=1

# Skip gcloud config set project step
make run SKIP_GCLOUD_CONFIG_SET_PROJECT=1

# Skip both steps
SKIP_GCLOUD_AUTH_LOGIN=1 SKIP_GCLOUD_CONFIG_SET_PROJECT=1 make run
```

## Testing Environment

The project uses a containerized Alpine Linux environment with:
- Claude Code CLI installed globally via npm
- Google Cloud SDK for authentication testing
- Network debugging tools (strace, tcpdump, tshark) for analyzing connection behavior
- A non-root `arista` user for realistic testing conditions

## Test Script Architecture

The `test.sh` script demonstrates the performance issue through a systematic approach:

1. **Setup Phase 1**: Application default login (`gcloud auth application-default login`)
2. **Test 1**: Run Claude Code - works but exhibits slow performance (~16 seconds)
3. **Setup Phase 2**: Additional authentication (`gcloud auth login` + project configuration)
4. **Test 2**: Run Claude Code again - demonstrates improved performance

## Environment Variables

- `VERTEX_PROJECT_ID` - Google Cloud project ID (default: `avalabs-sec-app-env`, customizable at build time)
- `SKIP_GCLOUD_AUTH_LOGIN` - Skip `gcloud auth login` step if set (optional)
- `SKIP_GCLOUD_CONFIG_SET_PROJECT` - Skip `gcloud config set project` step if set (optional)
- `CLAUDE_CODE_USE_VERTEX=1` - Enable Vertex AI backend
- `CLOUD_ML_REGION=us-east5` - Vertex AI region
- `ANTHROPIC_VERTEX_PROJECT_ID` - Project ID for Anthropic Vertex integration

The `VERTEX_PROJECT_ID` is set at container build time and can be customized using the Makefile as shown in the Build and Run Commands section.

## Docker Configuration

The container requires specific capabilities for network debugging:
- `--cap-add=NET_RAW` - For packet capture tools
- `--cap-add=SYS_PTRACE` - For system call tracing

These capabilities are automatically included in the `make run` command.
