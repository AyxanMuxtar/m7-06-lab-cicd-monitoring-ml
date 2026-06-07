# Vision Moderation — Rollback Runbook

## When to Roll Back

- [ ] Error rate > 1% for 5 minutes (Grafana: `vision-moderation / Error Rate`)
- [ ] P99 latency > 1 s for 5 minutes (Grafana: `vision-moderation / Latency`)
- [ ] Any `AvailabilityBurnFast` or `ModelVersionMismatch` alert fires
- [ ] Canary verification script fails (`canary-verify.sh` exits non-zero)
- [ ] Quality proxy (F1 on shadow traffic) drops > 5% from baseline

## How to Roll Back

```bash
# Option A: CLI rollback via the provided script
./scripts/rollback.sh production

# Option B: Trigger rollback workflow from GitHub
gh workflow run deploy-model.yml \
  -f action=rollback \
  -f environment=production
```

## What to Verify

- [ ] `AvailabilityBurnFast` alert resolves (Alertmanager)
- [ ] Error rate returns below 0.5% (Grafana: `vision-moderation / Error Rate`)
- [ ] P99 latency returns below 1 s (Grafana: `vision-moderation / Latency`)
- [ ] All replicas report the previous known-good `model_version` (Grafana: `vision-moderation / Model Version`)
- [ ] Smoke test passes: `./scripts/smoke.sh production`

## Who to Notify

| Channel                          | When           |
|----------------------------------|----------------|
| `#vision-moderation-incidents`   | Immediately    |
| On-call ML engineer (PagerDuty)  | Immediately    |
| `#ml-platform`                   | Within 15 min  |
| Engineering manager              | Post-mortem    |

## What NOT to Do

- **Do not** roll forward with a "quick fix" before root cause is identified.
- **Do not** skip the smoke test after rollback.
- **Do not** manually edit Kubernetes manifests in production — use the script/workflow.
- **Do not** silence alerts to "buy time." Fix the issue or roll back.

## When to Roll Forward

- Root cause is identified **and** fixed in a new commit.
- Fix passes the full pipeline (lint → test → build → scan → staging smoke).
- Canary verification succeeds for ≥ 15 minutes at 10% traffic.
- At least one peer has reviewed the fix PR.
