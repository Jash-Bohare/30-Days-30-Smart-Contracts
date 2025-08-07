# Day 2 – RentEscrow Smart Contract

## Problem Statement

In traditional rental agreements, tenants often hesitate to transfer a **security deposit + rent upfront** due to trust issues, while landlords fear late or non-payment. Manual contracts and offline agreements lead to **delays, disputes, and zero transparency**.

There’s a need for an **automated, trustless system** where both parties can **securely interact and complete rent transactions** based on mutual confirmation or time-based conditions.

---

## Solution

**RentEscrow** is a smart contract-based solution that acts as a **neutral third party** to hold the tenant's rent and deposit until:
- Both tenant and landlord confirm the transaction,
- Or a deadline passes.

This ensures **fairness, transparency, and automation** without relying on third-party trust.

---

## Key Features

- **Escrow Logic**: Funds are held securely until both parties confirm.
- **Time-based Auto Release**: Automatically releases funds if only one party confirms and the deadline passes.
- **Refund Option**: Tenant can withdraw funds before deadline if the landlord doesn’t confirm.
- **Status Tracking**: Frontend-friendly helper functions to fetch contract status and balance.
- **Fallback Protection**: Prevents accidental ETH transfers using fallback and receive.
- **Event Emissions**: Emits events for all major state changes for easy dApp integration.

---

## Solidity Concepts Used

**Modifiers**: Role-based access (`onlyTenant`, `onlyLandlord`), state check (`notCompleted`)
**Events**: Emitted for all important state changes: deposits, confirmations, releases 
**Require Statements**: Guards for validating actions (e.g., deadline, sender roles, amount checks) 
**Fallback/Receive**: Prevents accidental ETH transfers 
**`payable` functions**: To accept and transfer ETH
**Internal Function (`_releaseFunds`)**: DRY principle: used by confirm and auto release
**View Functions**: For getting contract status and balance
**State Management**: Flags for rentPaid, completed, confirmations ensure secure transitions

---

## License

MIT – Free to use, modify, and build upon.

---

## Follow the Full Series

This is **Day 2** of my 30 Days, 30 Smart Contracts challenge.  
Follow the repo for daily uploads of real-world smart contracts and use cases.
