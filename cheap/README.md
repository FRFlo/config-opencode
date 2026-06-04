# cheap profile

Use this profile when you want the lowest-cost setup.

## Requires

- OpenCode Go
- OpenAI

## Install

Linux / macOS:

```bash
OPENCODE_PROFILE=cheap curl -fsSL https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.sh | bash
```

Windows:

```powershell
$env:OPENCODE_PROFILE = "cheap"
irm https://github.com/FRFlo/config-opencode/raw/refs/heads/develop/setup.ps1 | iex
```

## Contains

- `opencode.json`
- `oh-my-openagent.json`
