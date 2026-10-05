---
name: gmail-connector
description: Read and draft Gmail emails using OAuth credentials. Use when you need to fetch, search, or draft emails via Gmail API with authenticated access.
---

# Gmail Connector Skill

## Purpose
Enable reading and drafting Gmail emails via Gmail API using OAuth 2.0 credentials stored securely.

## Safety Rules (Hard Constraints)
- **Draft-first enforcement:** Every outgoing email MUST be created as a Gmail draft first. Do NOT send emails automatically. The draft must be presented to the user for explicit review before sending.
- **Read before sending:** Show the draft contents (to, cc, bcc, subject, body) to the user and wait for explicit confirmation to send. Only send after user approval.
- **No secrets in chat/code:** Never paste passwords, API keys, tokens, or secrets into chat or code files. Store secrets in `.env` files or secure secret storage. If setting up secrets, do so via `.env` with user guidance.
- **Human approval required for send:** Sending is considered a destructive/external action and requires explicit human-in-the-loop confirmation.

## Prerequisites
- Google Cloud project with Gmail API enabled.
- OAuth 2.0 Desktop client: `credentials.json` at `.agent/config/google/credentials.json`.
- OAuth tokens: `token.json` at `.agent/config/google/token.json` (valid; auto-refresh supported).

## Security
- Never inline secrets/tokens in code/output.
- Access only via `.agent/config/google/` or env vars.
- Require explicit approval before sending emails (drafts only by default).

## Scopes
- `https://www.googleapis.com/auth/gmail.readonly` - read
- `https://www.googleapis.com/auth/gmail.compose` - draft/send

## Configuration
- Credentials: `.agent/config/google/credentials.json`
- Token: `.agent/config/google/token.json`

## Operations
- Read: list messages (supports `q` query), get message (full payload, snippet, headers).
- Draft: create draft (to, cc, bcc, subject, body text/html). Always use draft-first.
- Send: create/send message ONLY after explicit user approval of an existing draft or confirmed draft content.

## Auth
If token missing/expired, run OAuth flow via local server (port 0). Tokens auto-refresh when expired with refresh_token.

## Workflow
1. Compose email content.
2. Create Gmail draft via API.
3. Present draft details to user for review (read what was written).
4. Wait for explicit user confirmation to send. If not confirmed, leave as draft.
5. Send only upon explicit approval.

## Notes
- Gmail API requires user to be test user if consent is External/Testing.
- Authenticated user: zatalu@gmail.com.
