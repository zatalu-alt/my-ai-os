---
name: makos-prospecting
description: Makos Real Estate client-prospecting workflow. Finds verified consumer leads (buyers, tenants, sellers, landlords) using strict evidence rules. For each result records provenance (source, date, excerpt), enforces deduplication/preservation of notes/statuses, outputs CSV + Markdown report, and drafts brief first responses identifying Zeynep A. Talu-Balci, MSIRE · MSRED, Founding Broker · Makos Real Estate. Never invents leads/contact details; separates explicit inquiries from opportunities/referrals.
---

# Makos Prospecting Skill

## Purpose
Systematically identify potential consumer clients for Makos Real Estate: buyers, tenants, sellers, and landlords. Prioritize verifiable, explicit housing inquiries with traceable public sources.

## First Target
People who have explicitly requested a three-bedroom (3BR) rental in Brickell within the past 30 days.

## Research Rules (Hard Constraints)
- Use accessible public sources and available search tools only.
- Verify the original source and its date for every lead.
- Skip pages requiring login, paywall, or blocking access.
- Do not infer housing needs from wealth, job title, nationality, followers, likes, or other indirect signals.
- Do not invent people, contact details, budgets, dates, intent, or specifications.
- Separate explicit housing inquiries from possible opportunities and referral contacts.
- Return fewer results (including zero) when evidence is insufficient.
- Do not make claims about Unit 402's price, availability, or specifications until explicitly confirmed by current listing information.
- Never send or post anything; drafts only.

## For Each Result Record
Record all fields below. Mark missing information as `Unknown`.

- public_name_or_username: string or "Unknown"
- source_url: string (must be original source; no redirect-only links)
- supporting_excerpt: short verbatim/near-verbatim quote from source showing explicit request; or "Unknown"
- original_post_date: ISO 8601 date (YYYY-MM-DD) or "Unknown"
- research_date: ISO 8601 date (YYYY-MM-DD)
- location: e.g. "Brickell, Miami, FL" or "Unknown"
- budget: "Unknown" if not stated
- bedrooms: "Unknown" if not stated (must match 3BR for first target)
- timing: when they need (move-in/window) or "Unknown"
- public_contact_route: only if explicitly provided publicly and accessible (no private DMs assumed); else "Unknown"
- contact_invited: boolean or "Unknown" (true only if post explicitly invites contact)
- agent_already_involved: boolean or "Unknown"
- missing_information: comma-separated list or "Unknown"
- recommended_next_action: concrete, non-invasive next step (e.g. "Do not contact; wait for public invite" or specific safe action) or "Unknown"
- lead_type: one of [explicit_rental_inquiry, opportunity, referral, other] (explicit_rental_inquiry required for first target)
- notes: user notes/status preserved across runs (append-only; never overwrite existing notes)

## Output Artifacts
Create/maintain in output directory (default `./prospecting-output/makos-<YYYYMMDD-HHMMSS>/`):

1. `prospect-tracker.csv` - CSV with all fields above. 
   - Preserve existing notes/statuses on future runs.
   - Deduplicate results: treat (source_url, public_name_or_username) as key; if duplicate found, merge by preserving prior notes and updating research_date only if new evidence stronger; do not overwrite explicit user edits.
2. `prospect-report.md` - Human-readable report with summary, filters applied (target, date window, rules), results table, zero-results rationale if applicable, limitations.
3. `sources.json` - Provenance log: for each result include raw supporting excerpt, source_url, original_post_date, research_date, retrieval method (tool), and verification status.
4. `responses/draft-responses.md` - Brief, helpful first response drafts for each verified inquiry that explicitly invites public contact (or safe draft only if appropriate). Each draft must identify: "Zeynep A. Talu-Balci, MSIRE · MSRED, Founding Broker · Makos Real Estate". Do not send/post.
5. `notes.md` - Run metadata (tools used/available, search queries, access issues, blocked pages, inferences labeled as such, zero results explanation).

## Workflow
1. **Intake**: Confirm target (default first target). Parse constraints (past 30 days, location Brickell, 3BR rental). 
2. **Tool check**: Determine available research tools (web search, fetch). If required tools unavailable, explain exactly what is missing and stop (no fabricated/example leads).
3. **Search**: Construct precise queries targeting explicit requests (e.g. "3 bedroom rental wanted Brickell", "looking for 3BR rental Brickell", "need 3BR apt Brickell") filtered to last 30 days where possible. Prefer public forums/classifieds with accessible pages.
4. **Verify**: Fetch source page (if accessible, no login). Extract original post date and explicit request text. Reject if inferred.
5. **Filter**: Must be explicit inquiry (tenant/buyer/seller/landlord as appropriate), 3BR, Brickell, within past 30 days. Separate opportunities/referrals.
6. **Record**: Populate all fields, mark missing as Unknown.
7. **Deduplicate + preserve**: Load existing CSV if present; deduplicate by key; preserve notes/statuses.
8. **Draft responses**: Only for verified inquiries where public contact is invited; identify Makos broker identity exactly as specified.
9. **Output**: Write all artifacts with timestamps; include sources.json and notes.md.

## Makos Identity (exact)
Zeynep A. Talu-Balci, MSIRE · MSRED, Founding Broker · Makos Real Estate

## Special Notes
- Do not claim Unit 402 price/availability/specs until confirmed.
- Never write TBD/placeholder as fact; use Unknown.
- Treat model estimates as non-factual; do not include them as verified leads.
