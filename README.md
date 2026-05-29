# config-opencode

OpenCode configuration files:

- `opencode.json` — model, plugins, and MCP server configuration
- `oh-my-openagent.json` — per-agent and per-category model assignments

## Quick setup

### Windows (PowerShell)

```powershell
irm https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.ps1 | iex
```

Downloads both JSON config files into `%USERPROFILE%\.config\opencode\`.

### macOS / Linux

```bash
curl -fsSL https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.sh | bash
```

Downloads both JSON config files into `$HOME/.config/opencode/`.
