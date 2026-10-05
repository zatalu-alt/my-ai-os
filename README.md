# AIOS — AI Operating System

Personal agent operating system. Skills, configuration, memory, and helper scripts.

## Structure

```
.agent/
├── skills/               Skill definitions (markdown, YAML frontmatter)
│   ├── skill_builder.md      Create and improve skills
│   ├── orchestrator.md       Multi-agent DAG coordination
│   ├── admin_assistant.md    Orchestration + approvals
│   ├── gmail_connector.md    Read and draft Gmail
│   ├── go_to_market.md       GTM strategy site generator
│   └── go_to_market/
│       └── scripts/scrape.js Playwright scraper
├── config/
│   ├── skills.json        Skill registry
│   ├── .env.example       Secrets template — copy to .env
│   └── google/            OAuth credentials (gitignored)
├── memory/
│   └── context.json       Persistent context
└── scripts/              Auth and helper scripts
```

## Install

```bash
git clone https://github.com/zatalu-alt/my-ai-os.git
mv my-ai-os ~/.agent
```

## Secrets

Credentials are never committed. `config/google/` and any `.env` are gitignored.

```bash
cp config/.env.example config/.env   # then fill in values
```

For Gmail, download OAuth client JSON from Google Cloud Console and place it at
`config/google/credentials.json`, then run the auth flow:

```bash
pip3 install google-auth google-auth-oauthlib google-api-python-client
python3 scripts/gmail_auth.py
```

Tokens land in `config/google/token.json` (gitignored) and refresh automatically.

## Gmail safety rule

Every email is created as a **draft** first and shown for review before sending.
Nothing leaves the account without explicit approval.

## Registering a skill

Add the file to `skills/`, then register it in `config/skills.json`:

```json
{
  "skill-name": {
    "name": "skill-name",
    "description": "When to trigger and what it does.",
    "path": ".agent/skills/skill_name.md"
  }
}
```

## Go-to-market skill

```bash
/gtm <url-or-file-paths> [--company "Name"] [--out ./gtm-output]
```

Output goes to `<out>/<company-slug>-<timestamp>/` containing `index.html`
(standalone clickable site), screenshots, navigation recording, `sources.json`,
and `notes.md`. Requires:

```bash
npx playwright install chromium
```