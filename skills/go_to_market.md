---
name: go-to-market
description: GTM strategy skill. Given a company website URL or company documents, research and produce a standalone, click-through HTML GTM site covering sales, marketing, and customer success. Every claim traces to scraped pages, provided docs, or labeled inference.
---

# Go-To-Market Strategy Skill

## Purpose
Turn company inputs into a standalone interactive HTML GTM strategy site with full provenance.

## Trigger
- `/gtm <url-or-file-paths> [--company "Name"] [--out ./gtm-output]`
- User asks for GTM/go-to-market strategy

## Inputs
- url: string (optional)
- files: array of .txt, .md, .pdf (optional)
- company: string (optional; default from site title)
- out: dir (default ./gtm-output)
- At least one of url/files required

## Outputs (<out>/<company-slug>-<timestamp>/)
- index.html (single file, inline CSS/JS, relative paths)
- assets/screenshots/*.png
- assets/recordings/*.webm
- sources.json (raw text + citations)
- notes.md (analysis, failures, inferences)

## Required Sections (Order)
1. Company Overview (mission, vision, products/services, USPs)
2. Ideal Customer Profile (demographic/psychographic/behavioral; firmographic if B2B; roles, size, industry, pain, goals, today’s workaround)
3. Pain / Problem / Solution (core challenge, problem solved, differentiation)
4. Sales Funnel (awareness, lead gen, qualification, nurturing, proposal, close; per stage: channels, activities, 1 KPI)
5. Pitches (elevator <=30s, concise outreach, detailed product pitch; each must have problem, solution, UVP, CTA)
6. Marketing Plan
7. Customer Success Plan
8. 90-Day Plan (blocks: initial validation, foundational infra, pilot campaigns, KPI setup; weekly/30-day blocks; owner role, measurable outcome)
9. 12-Month Plan (quarterly objectives with KPIs, expansion, roadmap alignment, scaling, growth)
10. Other standard sections as evidence supports: Competitive Landscape, Positioning Statement, Pricing and Packaging Observations, KPIs, Risks and Open Questions

## Scraping
- Use Playwright (Chromium). Install via `npx playwright install chromium`.
- Priority pages: product/service, pricing, About Us, testimonials, blog, public whitepapers/case studies.
- Take full-page screenshots: homepage, pricing, product page, any cited page.
- Record short video: homepage -> pricing -> signup/demo (recordVideo context).
- Public pages only. Never login/submit forms/start trials/contact. If action outside required, stop and ask.

## Provenance
- Every claim traces to scraped page, provided doc, or step labeled "Inference".
- List all source pages in Sources section.
- Tag unsupported conclusions as "Inference". If evidence thin, say "Insufficient evidence" + questions.

## HTML UX
- Persistent nav, progress indicator, Prev/Next per section.
- Collapsible supporting detail.
- No external CDNs.

## Checks
- All required sections present.
- Each pitch has problem, solution, UVP, CTA.
- Both plans have measurable outcomes.
- Every embedded asset loads.
- No placeholder text.

## Execution
1. Validate inputs.
2. Scrape + parse docs (pdftotext for PDFs).
3. Save raw text to sources.json.
4. Draft notes.md before HTML.
5. Write all sections in order.
6. Build HTML.
7. Run checks.
8. Report paths.

## Error Handling
- Blocked/timeout/CAPTCHA: retry once; if fails again log in notes.md and continue.
- No URL loads: use files only and state in overview.
- If Playwright missing: install once; if install fails halt with clear message.
- Never overwrite folder; append timestamp to folder name.
