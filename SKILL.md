---
name: heptabase-cli
description: Interact with your Heptabase knowledge base from the terminal. Use when the user wants to search notes, read cards or journals, save new notes, append to journals, or work with PDFs in Heptabase. Triggers on mentions of "heptabase", "whiteboard", "journal", "note card", or "knowledge base".
argument-hint: "[command] [args]"
---

# Heptabase CLI

A CLI that wraps the Heptabase MCP server. Search, read, and write to your Heptabase knowledge base from the terminal.

## Prerequisites

- The `heptabase` binary must be on your PATH (see https://github.com/madeyexz/heptabase-cli)
- First run opens a browser for OAuth login; tokens cache in `~/.mcp-auth/`

## Commands

### Search

```bash
# Search whiteboards by keywords (1-5, comma-separated, OR logic)
heptabase search-whiteboards --keywords "topic1,topic2"

# Semantic search across cards, journals, PDFs, highlights
# --queries: 1-3 natural language queries, comma-separated
# --result-object-types: card,pdfCard,mediaCard,highlightElement,journal (or empty for all)
heptabase semantic-search-objects --queries "machine learning,neural networks" --result-object-types "card,pdfCard"

# Search within a specific PDF (BM25 keyword matching, up to 80 ranked chunks)
heptabase search-pdf-content --pdf-card-id <id> --keywords "term1,term2"
```

### Read

```bash
# Get full content of a specific object
# --object-type: card, journal, videoCard, audioCard, imageCard, highlightElement,
#                textElement, videoElement, imageElement, chat, chatMessage,
#                chatMessagesElement, section (NOT pdfCard — too large)
heptabase get-object --object-id <id> --object-type card

# Get all objects and connections on a whiteboard
heptabase get-whiteboard-with-objects --whiteboard-id <id>

# Fetch journal entries for a date range (max 92 days per call)
heptabase get-journal-range --start-date 2026-01-01 --end-date 2026-03-01

# Get specific pages from a PDF (pages start at 1)
heptabase get-pdf-pages --pdf-card-id <id> --start-page-number 1 --end-page-number 10
```

### Write

```bash
# Create a new note card in Inbox (first h1 line becomes the title)
heptabase save-to-note-card --content "# My Title

Body text in markdown"

# Append to today's journal (auto-creates if it doesn't exist)
heptabase append-to-journal --content "Some journal entry"
```

## Output Formats

All commands accept `--output <format>`:
- `text` (default) — human-readable
- `json` — structured JSON, good for piping into `jq`
- `markdown` — markdown formatted
- `raw` — raw MCP response

Example: `heptabase search-whiteboards --keywords "project" --output json`

## Common Workflows

### Find and read a note
1. `heptabase semantic-search-objects --queries "your topic" --result-object-types card` — find the object ID
2. `heptabase get-object --object-id <id> --object-type card` — read the full content

### Explore a whiteboard
1. `heptabase search-whiteboards --keywords "project name"` — find the whiteboard ID
2. `heptabase get-whiteboard-with-objects --whiteboard-id <id>` — see all objects and connections

### Review recent journals
```bash
heptabase get-journal-range --start-date 2026-02-01 --end-date 2026-02-21 --output json
```

### Search and read a PDF
1. `heptabase semantic-search-objects --queries "paper title" --result-object-types pdfCard` — find the PDF card ID
2. `heptabase search-pdf-content --pdf-card-id <id> --keywords "key concept"` — search within it
3. `heptabase get-pdf-pages --pdf-card-id <id> --start-page-number 1 --end-page-number 5` — read specific pages

## Global Flags

- `--timeout <ms>` — call timeout (default: 30000)
- `--raw <json>` — bypass flag parsing, pass raw JSON arguments directly
