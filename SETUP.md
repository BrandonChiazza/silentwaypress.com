# Setup notes — `silentwaypress.com`

One-time configuration outside the git repo. Everything below is set in the Cloudflare dashboard, not in code.

## DNS

Apex `silentwaypress.com` and `www.silentwaypress.com` are managed by Cloudflare. When the Pages project is wired in [`DEPLOY.md`](./DEPLOY.md) §3, Cloudflare adds the necessary CNAMEs automatically.

If Brandon transferred the domain in (not registered at Cloudflare originally):
1. Add the domain to Cloudflare.
2. Update nameservers at the previous registrar to point to the Cloudflare-assigned NS records.
3. Wait for propagation (usually 1–4 hours).
4. Then proceed with Pages → Custom domains setup.

## Email — Cloudflare Email Routing

The site exposes four `@silentwaypress.com` mailto addresses. Set these up in Cloudflare → silentwaypress.com → Email → **Email Routing**.

### Destination address(es)

Add at least one verified destination. Brandon's options:
- Personal: `brandon.chiazza@gmail.com`
- Modali: any verified mailbox on the `modali.com` zone
- Combined: a Google Workspace group that fans out to both

Cloudflare sends a verification email to each destination — click the link to activate.

### Routes

Once the destination is verified, add custom routes:

| Match | Action | Destination |
|---|---|---|
| `editorial@silentwaypress.com` | Send to email | (destination) |
| `rights@silentwaypress.com` | Send to email | (destination) |
| `press@silentwaypress.com` | Send to email | (destination) |
| `hello@silentwaypress.com` | Send to email | (destination) |
| `*@silentwaypress.com` (catch-all) | Send to email | (destination) |

The catch-all guards against future addresses (e.g., `submissions@`, `accounts@`, `legal@`) that the site may add later.

### Outbound mail

Cloudflare Email Routing is **receive-only**. To send mail *from* a `@silentwaypress.com` address (e.g., for editorial correspondence with prospective authors), Brandon needs a separate sending service:

- **Resend** (already in use for `operatingintelligence.org` and `twelvelaws.ai`): add `silentwaypress.com` as a sending domain in the Resend dashboard, verify DNS records (DKIM, SPF, return-path), then send via SMTP or API.
- **Google Workspace**: register the domain with Google Workspace; provides full mailboxes with both send and receive.
- **Fastmail / ProtonMail**: simpler than Google Workspace; sub-$10/month per address.

For initial press operations, Email Routing → Brandon's existing mailbox is sufficient. Sending-from upgrades can wait until there's volume that justifies them.

## SEO and indexing

The site exposes only one canonical page (`/`). No sitemap or robots.txt is shipped by default. If Brandon wants to add either later:

- `robots.txt` in repo root (allow everything by default; Cloudflare serves it directly via the assets binding)
- `sitemap.xml` with the single `/` entry — useful only if catalog pages expand to discrete title pages

## Analytics (optional)

The site ships with zero analytics scripts. If Brandon wants traffic insights without a third-party script:

- **Cloudflare Web Analytics**: free, privacy-friendly, no cookies. Enable in Cloudflare dashboard → silentwaypress.com → Analytics & Logs → Web Analytics → Add site. Cloudflare injects the tracking via the edge — no code change required.

I would *not* add Google Analytics, Plausible, or Fathom to a press site by default. The ground state is fine without tracking; the press is not a conversion funnel.

## Favicon

The current `favicon.png` is a placeholder copied from `operatingintelligence.org`. Before public launch, replace with a press-specific mark.

Recommended approach: open the SVG-based cover art for any title (currently the only one is Operating Intelligence) in a vector editor, extract a minimal monogram (e.g., the letters "SWP" set in Source Serif 4 Bold Italic in muted ochre on cream), export at 64×64 and 256×256.

A clean text-only favicon is appropriate for a press identity. Avoid book-cover thumbnails — those are for the title sites, not the press.

## Legal entity reference

The site footer reads "© 2026 Silent Way Press. All rights reserved." This is the imprint name, which (per Brandon's structure) operates as a DBA under **Silent Way Capital LLC** (Onondaga County, NY, 2021).

The site does **not** disclose the LLC name in the footer because the imprint is the public-facing identity and the LLC is the business-of-record. For legal correspondence (contracts, IP assignments, vendor agreements), use the LLC name; for editorial and press correspondence, use the imprint name.
