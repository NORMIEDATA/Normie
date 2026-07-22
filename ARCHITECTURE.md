# Architecture

High-level system design for Normie. Implementation details and source remain private.

## Components

### Client
Wallet connect (embedded / external), upload UX, portfolio, datasets, rewards, claim window, public audit view.

### API
Authenticated contribution intake, signed media upload params, vision verification orchestration, wallet-scoped reads, audit event append, Merkle batch computation.

### Verify
Server-side vision assessment for street-scene fitness:

- authentic real-world scene vs synthetic / useless  
- quality / originality scores  
- street labels (region, road type, weather, objects, …)  
- admit · review · reject  

Fail-closed when verification providers are unavailable.

### Data plane
Persistent store for datasets, assets, reward ledger, audit events, and batch roots.

### Media
Private object storage for contributor media; public dataset exposure is controlled and can include masking.

### Settlement
Robinhood Chain · ETH · chain ID `4663`.

Normie ops wallet → qualified contributor wallets after verification + reward allocation.

## Trust model (trial)

| Layer | Trust |
|-------|--------|
| Verification | Normie-operated vision pipeline |
| Ledger | Append-only events queryable in product |
| Merkle | Computed over verified fingerprints |
| Payouts | Custodial ops wallet (trial) |

On-chain Merkle anchors and/or claim contracts are optional upgrades — not required to run the trial supply network.

## What is intentionally private

- Application & API source  
- Exact model prompts & scoring weights  
- Infrastructure credentials  
- Database contents beyond public ledger views  
