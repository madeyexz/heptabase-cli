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
  --output ./heptabase-cli.ts \
  --compile ./heptabase \
  --description "Heptabase knowledge base CLI"
```

## Authentication

- First run opens a browser for Heptabase OAuth login
- Tokens are cached in `~/.mcp-auth/` and auto-refresh
- To force re-login: `rm -rf ~/.mcp-auth/`

## Usage

```bash
# Search
./heptabase search-whiteboards --keywords "topic1,topic2"
./heptabase semantic-search-objects --queries "machine learning" --result-object-types card

# Read
./heptabase get-object --object-id <id> --object-type card
./heptabase get-whiteboard-with-objects --whiteboard-id <id>
./heptabase get-journal-range --start-date 2026-01-01 --end-date 2026-02-21

# Write
./heptabase save-to-note-card --content "# Title\n\nBody text"
./heptabase append-to-journal --content "Some entry"

# PDF
./heptabase search-pdf-content --pdf-card-id <id> --keywords "term1,term2"
./heptabase get-pdf-pages --pdf-card-id <id> --start-page-number 1 --end-page-number 5

# Output formats: text (default), json, markdown, raw
./heptabase search-whiteboards --keywords "project" --output json
```

## Letting Every Agent Use It

### Claude Code

```bash
claude mcp add --transport http heptabase-mcp https://api.heptabase.com/mcp
```

### Cursor / Windsurf / VS Code

Add to your MCP config (e.g. `~/.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "heptabase-mcp": {
      "command": "npx",
      "args": ["-y", "mcp-remote@latest", "https://api.heptabase.com/mcp", "--transport", "http-only"]
    }
  }
}
```

### ChatGPT

Requires a Personal Plus Plan or higher (Team Plans don't support MCP). Add via ChatGPT's MCP settings with the endpoint `https://api.heptabase.com/mcp`.

### Codex / Any stdio-based MCP Client

Same pattern as Cursor — use `mcp-remote` as the command:

```json
{
  "mcpServers": {
    "heptabase-mcp": {
      "command": "npx",
      "args": ["-y", "mcp-remote@latest", "https://api.heptabase.com/mcp", "--transport", "http-only"]
    }
  }
}
```

### Non-MCP Agents (via this CLI)

For agents or scripts that can't speak MCP, use the compiled binary directly:

```bash
# Search from a shell script or agent
./heptabase semantic-search-objects --queries "quarterly review" --result-object-types card --output json

# Pipe into other tools
./heptabase get-journal-range --start-date 2026-02-01 --end-date 2026-02-21 --output json | jq '.content'
```

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
├── heptabase          # Compiled standalone binary (bun)
├── heptabase-cli.ts   # Generated TypeScript source
├── config/
│   └── mcporter.json  # mcporter server configuration
└── README.md
```
