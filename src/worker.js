/**
 * silentwaypress.com Worker
 *
 * The press site is fully static — no API routes, no email subscribe,
 * no PDF lead magnet. Brand sites differ from book sites by intent.
 *
 * This Worker exists to mirror the architecture of the sibling sites
 * (operatingintelligence.org, twelvelaws.ai) so the deploy flow,
 * wrangler config, and Cloudflare Pages binding all behave identically.
 * It serves static assets and does nothing else.
 */

export default {
  async fetch(request, env) {
    return env.ASSETS.fetch(request);
  },
};
