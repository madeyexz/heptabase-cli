# Heptabase CLI

CLI for your personal Heptabase knowledge base. Search whiteboards, read cards/journals/PDFs, and write notes from the terminal.

## Quick Start

### Step 1: Install CLI (pick one)

`bunx` (fastest start, requires [Bun](https://bun.sh/)):

```bash
bunx heptabase-cli --help
```

Standalone binary (no Bun required):

```bash
curl -L https://github.com/madeyexz/heptabase-cli/releases/latest/download/heptabase -o heptabase
chmod +x heptabase
sudo mv heptabase /usr/local/bin/
heptabase --help
```

### Step 2: If you use AI agents, add the skill

For Claude Code, Cursor, Codex, and [other agents](https://skills.sh/docs):

```bash
npx skills add madeyexz/heptabase-cli
```

This installs the skill metadata so compatible agents know when and how to use the `heptabase` command.

### Step 3: Run your first command

```bash
# no-install mode
bunx heptabase-cli search-whiteboards --keywords "project"

# installed binary
heptabase search-whiteboards --keywords "project"
```

## Installation

### Method A: `bunx` (no install)

Requires [Bun](https://bun.sh/).

```bash
bunx heptabase-cli search-whiteboards --keywords "project"
```

### Method B: standalone binary

Current release binary target: macOS arm64.
If you are on another platform, use Method A (`bunx`) or build from source.

```bash
curl -L https://github.com/madeyexz/heptabase-cli/releases/latest/download/heptabase -o heptabase
chmod +x heptabase
sudo mv heptabase /usr/local/bin/
heptabase --help
```

### Agent Setup (Step 2 For Agents)

```bash
npx skills add madeyexz/heptabase-cli
```

This installs the skill metadata so compatible agents know when and how to use the `heptabase` command.

## First Run Authentication

The first command opens a browser for Heptabase OAuth.

- Tokens are cached in `~/.mcp-auth/`
- Tokens auto-refresh
- Force re-login with: `rm -rf ~/.mcp-auth/`

## Install Troubleshooting

- `command not found: heptabase`: run with `bunx heptabase-cli ...` or confirm `/usr/local/bin` is on your `PATH`.
- Browser did not open for OAuth: copy the login URL from terminal into your browser manually.
- Need to reset login: `rm -rf ~/.mcp-auth/` and run any command again.

## Build From Source (Advanced)

Requires [Node.js](https://nodejs.org/) and [Bun](https://bun.sh/).

```bash
# 1) Authenticate with Heptabase (opens browser)
npx mcp-remote@latest https://api.heptabase.com/mcp --transport http-only

# 2) Generate and compile CLI
npx mcporter@latest generate-cli \
  --command 'npx -y mcp-remote@latest https://api.heptabase.com/mcp --transport http-only' \
  --output ./heptabase-cli.ts \
  --compile ./heptabase \
  --description "Heptabase knowledge base CLI"

# 3) Add to PATH
sudo ln -sf "$(pwd)/heptabase" /usr/local/bin/heptabase
```

## Commands

These examples use the installed binary (`heptabase`).
If you are using no-install mode, replace `heptabase` with `bunx heptabase-cli`.

### Search

```bash
heptabase search-whiteboards --keywords "topic1,topic2"
heptabase semantic-search-objects --queries "machine learning" --result-object-types card
heptabase search-pdf-content --pdf-card-id <id> --keywords "term1,term2"
```

### Read

```bash
heptabase get-object --object-id <id> --object-type card
heptabase get-whiteboard-with-objects --whiteboard-id <id>
heptabase get-journal-range --start-date 2026-01-01 --end-date 2026-02-21
heptabase get-pdf-pages --pdf-card-id <id> --start-page-number 1 --end-page-number 5
```

### Write

```bash
heptabase save-to-note-card --content "# Title\n\nBody text"
heptabase append-to-journal --content "Some entry"
```

### Output formats

All commands support `--output <format>`:

- `text` (default)
- `json`
- `markdown`
- `raw`

Example:

```bash
heptabase search-whiteboards --keywords "project" --output json
```

## Available Commands (Reference)

| Command | Description |
|---|---|
| `search-whiteboards` | Search whiteboards by keywords |
| `semantic-search-objects` | Hybrid full-text + semantic search across cards, journals, PDFs, highlights |
| `get-object` | Get full content of a card, journal, media, highlight, etc. |
| `get-whiteboard-with-objects` | Get all objects and connections on a whiteboard |
| `get-journal-range` | Fetch journal entries for a date range (max 92 days per call) |
| `save-to-note-card` | Create a new note card in your Inbox |
| `append-to-journal` | Append content to today's journal |
| `search-pdf-content` | BM25 keyword search within a PDF (up to 80 ranked chunks) |
| `get-pdf-pages` | Get specific page ranges from a PDF card |

## MCP + Agent Integrations

For MCP setup with Claude Code, Cursor, ChatGPT, and others, see the [official Heptabase MCP docs](https://support.heptabase.com/en/articles/12679581-how-to-use-heptabase-mcp).

## How This CLI Is Generated

Heptabase exposes an MCP server at `https://api.heptabase.com/mcp` with OAuth authentication.

This CLI is generated with [mcporter](https://github.com/steipete/mcporter/) using [mcp-remote](https://github.com/geelen/mcp-remote) as a stdio adapter for OAuth flow and token caching.

```bash
npx mcp-remote@latest https://api.heptabase.com/mcp --transport http-only

npx mcporter@latest generate-cli \
  --command 'npx -y mcp-remote@latest https://api.heptabase.com/mcp --transport http-only' \
  --output heptabase-cli.ts \
  --compile heptabase \
  --description "Heptabase knowledge base CLI"
```

## Project Structure

```text
heptabase-cli/
├── bin/
│   └── heptabase.js   # Node entry point (delegates to bun)
├── heptabase          # Compiled standalone binary (bun)
├── heptabase-cli.ts   # Generated TypeScript source
├── package.json       # npm package (bunx heptabase-cli)
├── .npmignore         # Excludes binary from npm tarball
├── SKILL.md           # Agent skill definition (skills.sh)
├── config/
│   └── mcporter.json  # mcporter server configuration
└── README.md
```
