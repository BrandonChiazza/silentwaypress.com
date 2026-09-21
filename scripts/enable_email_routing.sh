#!/usr/bin/env bash
# Enable Cloudflare Email Routing for silentwaypress.com and forward every
# address to one destination. Idempotent: safe to run twice.
#
#   CLOUDFLARE_API_TOKEN=... ./scripts/enable_email_routing.sh [destination-email]
#
# Token permissions (scope it to the silentwaypress.com zone and its account):
#   Zone   > Zone: Read
#   Zone   > DNS: Edit
#   Zone   > Email Routing Rules: Edit
#   Account> Email Routing Addresses: Edit
#
# The destination address gets a verification email from Cloudflare; routing
# starts only after that link is clicked.
set -euo pipefail

ZONE_NAME="silentwaypress.com"
DEST="${1:-brandon.chiazza@gmail.com}"
API="https://api.cloudflare.com/client/v4"
: "${CLOUDFLARE_API_TOKEN:?set CLOUDFLARE_API_TOKEN}"

cf() { curl -sS -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type: application/json" "$@"; }
ok() { python3 -c 'import sys,json; d=json.load(sys.stdin); print(json.dumps(d.get("result"), indent=1) if d.get("success") else "ERROR: "+json.dumps(d.get("errors")))'; }

echo "== zone"
ZONE_JSON=$(cf "$API/zones?name=$ZONE_NAME")
ZONE_ID=$(echo "$ZONE_JSON" | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["result"][0]["id"])')
ACCOUNT_ID=$(echo "$ZONE_JSON" | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["result"][0]["account"]["id"])')
echo "zone $ZONE_ID account $ACCOUNT_ID"

echo "== enable email routing (adds MX and SPF records automatically)"
cf -X POST "$API/zones/$ZONE_ID/email/routing/enable" | ok || true
cf "$API/zones/$ZONE_ID/email/routing" | ok

echo "== destination address $DEST (verification email goes out on first creation)"
EXISTING=$(cf "$API/accounts/$ACCOUNT_ID/email/routing/addresses?per_page=50" | python3 -c 'import sys,json; d=json.load(sys.stdin); print(json.dumps([a["email"] for a in d.get("result",[])]))')
if echo "$EXISTING" | grep -q "\"$DEST\""; then echo "already registered"; else
  cf -X POST "$API/accounts/$ACCOUNT_ID/email/routing/addresses" --data "{\"email\":\"$DEST\"}" | ok
fi

echo "== rules"
RULES=$(cf "$API/zones/$ZONE_ID/email/routing/rules?per_page=50" | python3 -c 'import sys,json; d=json.load(sys.stdin); print(json.dumps([m["value"] for r in d.get("result",[]) for m in r.get("matchers",[]) if m.get("type")=="literal"]))')
for p in press hello editorial rights brandon; do
  ADDR="$p@$ZONE_NAME"
  if echo "$RULES" | grep -q "\"$ADDR\""; then echo "rule exists: $ADDR"; continue; fi
  cf -X POST "$API/zones/$ZONE_ID/email/routing/rules" --data "{\"name\":\"$p\",\"enabled\":true,\"matchers\":[{\"type\":\"literal\",\"field\":\"to\",\"value\":\"$ADDR\"}],\"actions\":[{\"type\":\"forward\",\"value\":[\"$DEST\"]}]}" | ok
done

echo "== catch-all"
cf -X PUT "$API/zones/$ZONE_ID/email/routing/rules/catch_all" --data "{\"name\":\"catch-all\",\"enabled\":true,\"matchers\":[{\"type\":\"all\"}],\"actions\":[{\"type\":\"forward\",\"value\":[\"$DEST\"]}]}" | ok

echo "== DNS check (anything listed as missing needs adding)"
cf "$API/zones/$ZONE_ID/email/routing/dns" | ok

echo
echo "Next: click the verification link Cloudflare sent to $DEST, then: dig +short MX $ZONE_NAME"
