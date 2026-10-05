# AIOS — AI Operating System

Personal agent operating system. Skills, configuration, memory, and helper scripts.

## Structure

```
.agent/
├── skills/
│   ├── skill_builder/          Skill creation, eval, benchmarking
│   │                          (Anthropic skill-creator, replaces empty stub)
│   ├── humanizer/             Strip AI tone from prose (MIT)
│   ├── orchestrator.md        Multi-agent DAG coordination
│   ├── admin_assistant.md     Orchestration + human approval gates
│   ├── gmail_connector.md     Read and draft Gmail (draft-first)
│   ├── go_to_market.md        GTM strategy site generator
│   └── go_to_market/
│       └── scripts/scrape.js  Playwright scraper
├── config/
│   ├── skills.json            Skill registry
│   ├── .env.example           Secrets template — copy to .env
│   └── google/                OAuth credentials (gitignored)
├── memory/
│   └── context.json           Persistent context
├── scripts/
│   ├── gmail_auth.py          OAuth flow
│   └── backup.sh              Weekly backup, run by launchd
├── vendor/
│   ├── catalog.json           What was reviewed, installed, and why
│   └── repos/                 Vendored upstream repos (.git stripped)
└── .backup.log                Backup run history (gitignored)
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

## Weekly backup

A launchd job commits and pushes local `.agent` changes every **Sunday at 23:00**.

- Schedule: `~/Library/LaunchAgents/com.aios.weekly-backup.plist`
- Script: `scripts/backup.sh` (writes history to `.backup.log`)
- Secrets are re-blocked at runtime and the script aborts if any credential-like
  file is staged.

Useful commands:

```bash
launchctl list | grep aios                        # confirm loaded
launchctl kickstart -p gui/$(id -u)/com.aios.weekly-backup   # run now
tail -f ~/.agent/.backup.log                      # watch the log
launchctl bootout gui/$(id -u)/com.aios.weekly-backup       # uninstall
```

Requires macOS to be awake at the scheduled time. Missed runs do not backfill;
any unpushed changes go out on the next Sunday.

## Vendored repos

`vendor/catalog.json` records eight upstream repos that were reviewed, what each
one actually is, and why it was installed or held back. Read it before adding more.

Only genuinely droppable skills are registered in `config/skills.json`. Tooling,
plugin marketplaces and training harnesses are vendored for reference only — see
the catalog for why `context-mode`, `claude-plugins-official` and `autoresearch`
are not skills.
