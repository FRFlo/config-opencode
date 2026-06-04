# config-opencode

OpenCode configuration profiles for two use cases:

- `cheap/` — requires **OpenCode Go + OpenAI**.
- `perf/` — requires **OpenAI only**.

Each profile ships the same two files:

- `opencode.json` — model, plugins, and MCP server configuration
- `oh-my-openagent.json` — per-agent and per-category model assignments

## Installation

The installers prompt you to choose `cheap` or `perf` if you do not pass a profile explicitly. They copy the selected profile into `~/.config/opencode/` on every platform.

### Linux / macOS

```bash
curl -fsSL https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.sh | bash
```

### Windows

```powershell
irm https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.ps1 | iex
```

### Non-interactive install

Set `OPENCODE_PROFILE=cheap` or `OPENCODE_PROFILE=perf` before running the installer.

```bash
OPENCODE_PROFILE=perf curl -fsSL https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.sh | bash
```

```powershell
$env:OPENCODE_PROFILE = "cheap"
irm https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.ps1 | iex
```
