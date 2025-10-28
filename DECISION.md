# Implementation Decisions

- **Images**: Used `yimikaade/wonderful:1.0` (Blue) and `yimikaade/wonderful:2.0` (Green) per provided links.
- **Upstreams**: Separate configs in `nginx/` for blue/green, swapped via `entrypoint.sh`.
- **Timeouts**: 1s connect, 3s send/read, 5s fail_timeout for <10s requests.
- **Retries**: `proxy_next_upstream` for error/timeout/5xx.
-  **Headers**: Added `X-App-Pool` in Nginx if app doesn’t set it, ensuring compliance with task requirements.
- **X-App-Pool Header**: The yimikaade/wonderful:devops-stage-two image sets X-App-Pool: unknown. Added proxy_set_header X-App-Pool $ACTIVE_POOL in Nginx to ensure correct blue/green values per task requirements.
- **Ports**: Assumed 80 (adjust to 3000 if needed).
- **Nginx Failure**: Debugged connection refused by ensuring port 3000 and checking for port conflicts.
- **Healthchecks**: Docker `/healthz` checks for orchestration.
- **Nginx Error**: Fixed invalid proxy_set_header syntax by adding fallback "${ACTIVE_POOL:-blue}".

Meets requirements: auto-failover, header forwarding, parameterization.