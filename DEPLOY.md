# Deploying `silentwaypress.com`

Same architecture as `twelvelaws.ai` and `operatingintelligence.org` — Cloudflare Pages connected to a GitHub repo, auto-deploys on push to `main`. The Worker (`src/worker.js`) only serves static assets; no API routes, no Resend, no secrets to configure.

## One-time setup (do this once)

### 1. Create the GitHub repo

```bash
cd /Users/brandon/workspace/projects/teaching/silentwaypress.com
git init
git add -A
git commit -m "Initial commit — Silent Way Press identity site"
git branch -M main
git remote add origin git@github.com:brandonchiazza/silentwaypress.com.git
git push -u origin main
```

(Per Brandon's request, this repo lives under his personal GitHub account at `brandonchiazza/silentwaypress.com` — not the `OperatingIntelligence` org that holds the book-marketing sites. The press is a separately-branded entity.)

### 2. Connect Cloudflare Pages

Cloudflare dashboard → Workers & Pages → Create → Pages → Connect to Git.

- Select repo: `brandonchiazza/silentwaypress.com`
- Production branch: `main`
- Build settings:
  - Build command: *(none)*
  - Build output directory: `/`
- Click **Save and Deploy**.

First deploy completes in 30–90 seconds. The site will be live at `silent-way-press.pages.dev` immediately.

### 3. Wire the custom domain

In the new Pages project → **Custom domains** → Add:

- `silentwaypress.com` (apex — primary)
- `www.silentwaypress.com` (Cloudflare creates the redirect automatically)

Cloudflare DNS should already manage `silentwaypress.com` since Brandon purchased through Cloudflare (or transferred to Cloudflare). If it's registered elsewhere, point the nameservers to Cloudflare first.

### 4. Wire the email addresses

The site exposes four mailto links:

- `editorial@silentwaypress.com`
- `rights@silentwaypress.com`
- `press@silentwaypress.com`
- `hello@silentwaypress.com`

The simplest way to receive mail at these addresses without standing up a full mailbox is **Cloudflare Email Routing** (free, included with the Cloudflare domain). It forwards each `@silentwaypress.com` address to a destination of Brandon's choice (likely `brandon.chiazza@gmail.com` or a Modali mailbox).

Cloudflare dashboard → silentwaypress.com → Email → Email Routing → Add routes for the four prefixes above. Each rule: `prefix@silentwaypress.com → brandon's destination`.

A catch-all rule (`*@silentwaypress.com`) is recommended as a fallback so any future address (e.g., `submissions@`, `legal@`) routes correctly without a new rule.

## Ongoing deploys

Edit `index.html` (or any other file), commit, push:

```bash
git add -A
git commit -m "Describe the change"
git push
```

Cloudflare Pages picks up the push and auto-deploys within 30–90 seconds. No `wrangler deploy` needed — that command applies only if Brandon wants to deploy via the Wrangler CLI instead of the Git-connected pipeline.

## Reverting

```bash
git revert <commit-sha>
git push
```

Or via Cloudflare dashboard → Pages project → Deployments → Rollback to any prior deployment.

## Differences from the sibling sites

| Concern | `operatingintelligence.org` | `twelvelaws.ai` | `silentwaypress.com` |
|---|---|---|---|
| GitHub org | OperatingIntelligence | OperatingIntelligence | **brandonchiazza** |
| Worker secrets | RESEND_*, PDF_URL | RESEND_*, PDF_URL | **none** |
| Email subscribe | yes | yes | no |
| Outbound to book sites | (self) | (cross-link) | catalog-style only, not promotional |
| Visual palette | Indigo / cream / gold | Indigo / cream / gold | **Paper cream / ink / muted ochre** |

The press site does not share the book sites' navy/gold identity because Silent Way Press is the publishing house, not the title.
