# Blue/Green Node.js Deployment with Nginx Auto-Failover

This setup deploys two identical Node.js services (Blue and Green) behind Nginx for zero-downtime failover. Traffic routes to the active pool (default: Blue) with automatic switch to backup on failure (5xx, timeout). Custom headers (`X-App-Pool`, `X-Release-Id`) are forwarded unchanged.

## Prerequisites
- Docker and Docker Compose installed.
- Replace image URLs in `.env` with provided links.

## Setup
1. Copy `.env.example` to `.env` and edit values (e.g., images, release IDs).
2. Run `docker compose up -d` to start services.

- Nginx: http://localhost:8080 (public endpoint)
- Blue direct: http://localhost:8081 (for chaos injection)
- Green direct: http://localhost:8082

## Verification
- Baseline: `curl -v http://localhost:8080/version` → 200, `X-App-Pool: blue`, `X-Release-Id: ${RELEASE_ID_BLUE}`
- Induce chaos: `curl -X POST http://localhost:8081/chaos/start?mode=error`
- Post-failover: `curl -v http://localhost:8080/version` → 200, `X-App-Pool: green`, `X-Release-Id: ${RELEASE_ID_GREEN}`
- Requests during failure: ≥95% 200s from Green, 0 non-200s (test with loop: `for i in {1..20}; do curl -w "\n" http://localhost:8080/version; done`)

## Manual Toggle
To switch active pool:
1. Edit `.env` (e.g., `ACTIVE_POOL=green`).
2. Run `docker compose restart nginx` (re-runs entrypoint to update upstreams).
3. Nginx configs are in `nginx/`; supports `nginx -s reload` for minor changes (`docker compose exec nginx nginx -s reload`).

## Chaos Recovery
- Stop chaos: `curl -X POST http://localhost:8081/chaos/stop`
- Blue recovers after `fail_timeout`.

## Notes
- No app code changes; uses provided images.
- Failover ensures client sees 200 (retries within ~7s total).
- Health checks on apps for Docker awareness (not used by Nginx).
## Notes
- App uses port 3000 internally (updated in docker-compose.yml and Nginx upstreams).
- X-App-Pool set by Nginx due to app returning unknown.