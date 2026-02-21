# Heptabase CLI

CLI for your personal Heptabase knowledge base. Search whiteboards, read cards/journals/PDFs, and write notes from the terminal.

Ported from Official [Heptabase MCP](https://support.heptabase.com/en/articles/12679581-how-to-use-heptabase-mcp) via [MCP Porter](https://github.com/steipete/mcporter/).


## Install

Pick one:

### Option 1: Homebrew (recommended on macOS)

```bash
brew tap madeyexz/tap
brew install madeyexz/tap/heptabase-cli
heptabase --help
```

### Option 2: Standalone binary

After install, use `heptabase` for all commands.

Current release binary target: macOS arm64.
If you are on another platform, use `bunx` or build from source.

```bash
mkdir -p ~/.local/bin
curl -L https://github.com/madeyexz/heptabase-cli/releases/latest/download/heptabase -o ~/.local/bin/heptabase
chmod +x ~/.local/bin/heptabase
~/.local/bin/heptabase --help
```

If `~/.local/bin` is not in your `PATH`, add it:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Optional system-wide install:

```bash
curl -L https://github.com/madeyexz/heptabase-cli/releases/latest/download/heptabase -o heptabase
chmod +x heptabase
sudo mv heptabase /usr/local/bin/
```

### Option 3: `bunx` (no install, requires [Bun](https://bun.sh/))

```bash
bunx heptabase-cli --help
```

For agents, prefer installing `heptabase` on `PATH`.

If you use AI agents (Claude Code, Codex, etc.), consider installing heptabase [heptabase agent skill](SKILL.md):

```bash
npx skills add madeyexz/heptabase-cli
```

Agent command convention: use `heptabase ...` (not `bunx heptabase-cli ...`).

## Authentication (First Run)

Run any command (examples below). The first run opens a browser for Heptabase OAuth.

- Tokens are cached in `~/.mcp-auth/`
- Tokens auto-refresh
- Reset login with `rm -rf ~/.mcp-auth/`

## Usage

Examples below use installed binary `heptabase`.
If you use no-install mode, replace `heptabase` with `bunx heptabase-cli`.

```bash
# Search
heptabase search-whiteboards --keywords "project"
heptabase semantic-search-objects --queries "machine learning" --result-object-types card

# Read
heptabase get-object --object-id <id> --object-type card
heptabase get-journal-range --start-date 2026-01-01 --end-date 2026-02-21

# Write
heptabase save-to-note-card --content "# Title\n\nBody text"
heptabase append-to-journal --content "Some entry"
```

List all commands:

```bash
heptabase --help
heptabase <command> --help
```

Supported output formats (`--output`): `text` (default), `json`, `markdown`, `raw`.

## Commands

- `search-whiteboards`
- `semantic-search-objects`
- `get-object`
- `get-whiteboard-with-objects`
- `get-journal-range`
- `save-to-note-card`
- `append-to-journal`
- `search-pdf-content`
- `get-pdf-pages`

## Troubleshooting

- `command not found: heptabase`: use `bunx heptabase-cli ...` or ensure `~/.local/bin` (or `/usr/local/bin`) is in your `PATH`.
- Browser did not open for OAuth: copy the login URL from terminal and open it manually.
- Need to re-authenticate: `rm -rf ~/.mcp-auth/` and run a command again.

## Development (Advanced)

Requires [Node.js](https://nodejs.org/) and [Bun](https://bun.sh/).

```bash
npx mcp-remote@latest https://api.heptabase.com/mcp --transport http-only

npx mcporter@latest generate-cli \
  --command 'npx -y mcp-remote@latest https://api.heptabase.com/mcp --transport http-only' \
  --output ./heptabase-cli.ts \
  --compile ./heptabase \
  --description "Heptabase knowledge base CLI"
```

## More

- Heptabase MCP docs: https://support.heptabase.com/en/articles/12679581-how-to-use-heptabase-mcp
- This CLI is generated with [mcporter](https://github.com/steipete/mcporter/) + [mcp-remote](https://github.com/geelen/mcp-remote)
