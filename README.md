# SiftGate on Railway

[SiftGate](https://github.com/seanbabalala/SiftGate) (MIT): a self-hosted AI gateway for team AI governance. Give every app or teammate a scoped gateway key, route OpenAI/Anthropic-compatible traffic to your providers, and enforce budgets, rate limits and policy namespaces with metadata-only audit logs. Deploy it on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/TEMPLATE_CODE)

## What this template runs
- **siftgate**: `ghcr.io/onepush-dev/siftgate:v2.14.0`, built from upstream's own Dockerfile at tag `v2.14.0` (application unmodified). One volume at `/app/data` holds the SQLite database and the gateway config. Listens on port 8080; health check `/live` (readiness `/ready`).

On first boot `railway/start.sh` writes `/app/data/gateway.config.yaml` from upstream's example config (port 8080, `trust_proxy: true`, SQLite at `/app/data/gateway.db`) and sets `dashboard.password` from `SIFTGATE_DASHBOARD_PASSWORD`. SiftGate hashes the password with bcrypt and writes the hash back to the file.

## Variables
| Variable | Value |
|---|---|
| `SIFTGATE_DASHBOARD_PASSWORD` | `${{secret(24)}}`: Dashboard login password (generated per deploy, used on first boot) |
| `SIFTGATE_DASHBOARD_SESSION_SECRET` | `${{secret(48)}}`: stable signing secret for Dashboard sessions |

Baked defaults: `NODE_ENV=production`, `SIFTGATE_HOST=0.0.0.0`, `GATEWAY_CONFIG_PATH=/app/data/gateway.config.yaml`.

## After deploy
1. Open the Railway URL and sign in to the Dashboard with `SIFTGATE_DASHBOARD_PASSWORD`.
2. Add provider keys as service variables (for example `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`); the default config references them as `${env:...}`, so nothing secret is written to the YAML.
3. Create client gateway keys in the Dashboard and point your apps at `https://<your-domain>/v1`.

Changing `SIFTGATE_DASHBOARD_PASSWORD` after the first boot has no effect; change the password in the Dashboard (or edit the config on the volume). Docs: https://github.com/seanbabalala/SiftGate/tree/main/docs

Not affiliated with SiftGate.
