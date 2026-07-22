# Normie smart contracts

Public on-chain payout rail for verified Normie Streets contributions.

## NormiePayouts (live)

| Field | Value |
|-------|--------|
| Network | Robinhood Chain |
| Chain ID | `4663` |
| Address | [`0xc5fc6241f3680f37e718c6fed99fa5352d872558`](https://robinhoodchain.blockscout.com/address/0xc5fc6241f3680f37e718c6fed99fa5352d872558) |
| Deploy tx | [`0x1d86f3949f66725a324b7db61c46a3f174d81134ef4cffebfe3ed87f086c876d`](https://robinhoodchain.blockscout.com/tx/0x1d86f3949f66725a324b7db61c46a3f174d81134ef4cffebfe3ed87f086c876d) |
| Owner / deployer | [`0x70FAFAda131734AAE25864049496e0E6C3f9E0eA`](https://robinhoodchain.blockscout.com/address/0x70FAFAda131734AAE25864049496e0E6C3f9E0eA) |
| Max pays / wallet / UTC day | `3` |
| Bounty (trial) | ~**$1** of ETH per verified photo |

Source: [`NormiePayouts.sol`](./NormiePayouts.sol)  
Deployment record: [`robinhood-4663.json`](./robinhood-4663.json)

## How payouts work

```text
Photo upload → AI agent verifies (strict) → Normie Asset ID
                         ↓
              operator calls pay(to, amountWei, assetId)
                         ↓
              ETH transfers to contributor wallet (instant)
```

Guarantees on-chain:

- **One pay per asset** (`assetId` = hash of Normie Asset ID)
- **Daily cap** per wallet (starts at 3)
- Only an **operator** (or owner) can call `pay`
- Contract must be **funded with ETH** before payouts succeed

## What stays private

Application source, AI agent prompts/keys, operator private keys, and infrastructure credentials are **not** published here.

## Verify on explorer

- Contract: https://robinhoodchain.blockscout.com/address/0xc5fc6241f3680f37e718c6fed99fa5352d872558  
- Watch `Paid(address to, uint256 amount, bytes32 assetId, uint256 day)` events for live settlements
