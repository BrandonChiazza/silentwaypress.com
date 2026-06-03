# silentwaypress.com

The public website for **Silent Way Press** — an independent imprint based in Ithaca, New York, founded by Brandon Chiazza in 2026.

This is a **press identity site**, not a book landing page. It does not market individual titles or run lead-magnet flows. Its job is to establish Silent Way Press as a serious publishing house and provide the operational surface for editorial inquiries, submissions, rights, and press correspondence. Outbound links to title-specific marketing sites (e.g. `operatingintelligence.org`) are framed as informational, not promotional.

---

## What this repo contains

```
silentwaypress.com/
├── index.html         # The full single-page site
├── favicon.png        # Placeholder favicon (replace before launch)
├── wrangler.toml      # Cloudflare Worker / Pages config
├── src/
│   └── worker.js      # Worker — static asset serving only, no API
├── README.md          # This file
├── DEPLOY.md          # Deploy instructions (GitHub + Cloudflare Pages)
└── SETUP.md           # Custom-domain + DNS + email setup
```

Single static page. Fonts via Google Fonts CDN. Tailwind via CDN. No build step, no node_modules, no JS framework.

## Visual identity (intentional contrast with the book brand)

The book brand (Operating Intelligence / Twelve Laws) uses **navy + cream + gold** with serif title display and an arch illustration. The press brand is **separate**, using:

- **Warm cream paper** ground (`#F6F2E8`) — editorial, not promotional
- **Near-black ink** (`#1A1A1A`) for type
- **Muted ochre** (`#8C6E3A`) as the single accent — quieter than the book's gold
- **Source Serif 4** throughout — the press identity is fully serif
- **Inter** for small-caps section eyebrows and footer chrome only
- **No CTAs, no buttons, no lead magnets** — the press is not asking the visitor for anything

The press should read like Princeton University Press or W. W. Norton's house page, not like a Shopify storefront.

## Tone

- Restrained, declarative, editorial.
- First person plural ("we publish," "we edit") because the press is the speaker — not Brandon personally.
- Sentences that could appear in a serious magazine, not a marketing email.

When updating copy, avoid: "exciting," "transformative," "exceptional," "groundbreaking," "industry-leading," exclamation marks, CTA-style phrasing.

## How to update

### Edit copy
Open `index.html`. Sections are clearly commented. Tailwind utility classes carry the styling — almost never edit the `<style>` block.

### Add a new title to the catalog
In the `#catalog` section, copy the existing `<article>` block, fill in the new title's metadata (eyebrow date, title, subtitle, author, description, format, ISBN, link). Place the new article above the existing one (most recent first). The `<hr>` and the *"Additional titles are announced as they enter production."* line stay at the bottom of the section.

### Replace the favicon
The current `favicon.png` is a placeholder copied from `operatingintelligence.org`. Before public launch, replace with a press-specific mark — recommended: a simple monogram `SWP` or `S` in serif on the cream paper ground.

## Deploy

See [`DEPLOY.md`](./DEPLOY.md).

## Local preview

The site is plain HTML; no server required:

```bash
cd silentwaypress.com
open index.html
# or, for a proper localhost server:
python3 -m http.server 8000
# then open http://localhost:8000
```

For a wrangler-equivalent local run (matches what Cloudflare serves):

```bash
npx wrangler dev
```

## License

Site code: MIT.
Press identity, name, and content: © 2026 Silent Way Press. All rights reserved.
