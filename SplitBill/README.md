# Day 1 – SplitBill Smart Contract

## Problem Statement

Splitting bills with friends (like food, rent, trips) often turns into a mess — people forget, overpay, or ghost entirely.  
The goal is to automate the **collection and distribution of shared expenses** using a smart contract, ensuring transparency and trust between all participants.

---

## Solution

The **SplitBill** contract allows a bill creator to:
- Define a group of participants
- Assign each a specific share (or equal split)
- Automatically collect payments
- Automatically release the total amount to the bill owner when everyone has paid

---

## Key Features

- Supports custom or equal splits  
- Prevents overpayment and double payments  
- Auto-distributes funds to the bill owner once the total is collected  
- Transparent and verifiable contributions  
- Only listed participants can pay

---

## Solidity Concepts Used

- `mapping(address => uint)` for tracking owed & paid amounts  
- `address[]` arrays for participant management  
- `msg.sender` and `msg.value` for payment logic  
- `require()` statements for input validation  
- `payable` functions for ETH transfer  
- Events for logging transactions  
- Modifiers for access control

---

## License

MIT – Free to use, modify, and build upon.

---

## Follow the Full Series

This is **Day 1** of my 30 Days, 30 Smart Contracts challenge.  
Follow the repo for daily uploads of real-world smart contracts and use cases.
