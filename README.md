# Heptabase CLI

A standalone CLI that wraps the [Heptabase MCP server](https://support.heptabase.com/en/articles/12679581-how-to-use-heptabase-mcp) into a command-line tool, built with [mcporter](https://github.com/steipete/mcporter/).

## How It Was Built

Heptabase exposes an MCP server at `https://api.heptabase.com/mcp` with OAuth authentication. The key insight is using [mcp-remote](https://github.com/geelen/mcp-remote) as a stdio adapter — it handles the OAuth browser flow and token caching, then mcporter wraps the resulting stdio MCP server into a CLI.

```bash
# 1. Authenticate with Heptabase (opens browser for OAuth)
npx mcp-remote@latest https://api.heptabase.com/mcp --transport http-only

# 2. Generate and compile the CLI
npx mcporter@latest generate-cli \
  --command 'npx -y mcp-remote@latest https://api.heptabase.com/mcp --transport http-only' \
  --output heptabase-cli.ts \
  --compile heptabase \
  --description "Heptabase knowledge base CLI"
```

## Authentication

- First run opens a browser for Heptabase OAuth login
- Tokens are cached in `~/.mcp-auth/` and auto-refresh
- To force re-login: `rm -rf ~/.mcp-auth/`

## Installation

### As an Agent Skill

Install as a skill for Claude Code, Cursor, Codex, and [other agents](https://skills.sh/docs):

```bash
npx skills add madeyexz/heptabase-cli
```

This makes `/heptabase-cli` available as a slash command in your agent.

### Via bunx (no install needed)

Requires [Bun](https://bun.sh/).

```bash
bunx heptabase-cli search-whiteboards --keywords "project"
```

### Download binary from GitHub Releases

```bash
curl -L https://github.com/madeyexz/heptabase-cli/releases/latest/download/heptabase -o heptabase
chmod +x heptabase
sudo mv heptabase /usr/local/bin/
```

### Build from source

Requires [Node.js](https://nodejs.org/) and [Bun](https://bun.sh/).

```bash
# 1. Authenticate with Heptabase (opens browser for OAuth)
npx mcp-remote@latest https://api.heptabase.com/mcp --transport http-only

# 2. Generate and compile
npx mcporter@latest generate-cli \
  --command 'npx -y mcp-remote@latest https://api.heptabase.com/mcp --transport http-only' \
  --output ./heptabase-cli.ts \
  --compile ./heptabase \
  --description "Heptabase knowledge base CLI"

# 3. Add to PATH
sudo ln -sf "$(pwd)/heptabase" /usr/local/bin/heptabase
```

### Verify

```bash
heptabase --help
```

## Usage

```bash
# Search
heptabase search-whiteboards --keywords "topic1,topic2"
heptabase semantic-search-objects --queries "machine learning" --result-object-types card

# Read
heptabase get-object --object-id <id> --object-type card
heptabase get-whiteboard-with-objects --whiteboard-id <id>
heptabase get-journal-range --start-date 2026-01-01 --end-date 2026-02-21

# Write
heptabase save-to-note-card --content "# Title\n\nBody text"
heptabase append-to-journal --content "Some entry"

# PDF
heptabase search-pdf-content --pdf-card-id <id> --keywords "term1,term2"
heptabase get-pdf-pages --pdf-card-id <id> --start-page-number 1 --end-page-number 5

# Output formats: text (default), json, markdown, raw
heptabase search-whiteboards --keywords "project" --output json
```

For MCP setup with Claude Code, Cursor, ChatGPT, etc., see the [official Heptabase MCP docs](https://support.heptabase.com/en/articles/12679581-how-to-use-heptabase-mcp).

## Available Commands

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

## Project Structure

```
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
