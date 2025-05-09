# Team-RentSure

## 🚀 Overview
RentSure is an open-source rental management platform for arbiters, landlords, and renters, which employs blockchain technology towards streamlining rentals. It addresses the underlying trust issue in rental agreements with the use of escrow-based smart contracts, token-gated document read-only, and credit scoring on chain.

Traditional rental systems are marred with delayed payments, unverifiable histories, and dispute resolution with no neutral mechanism. RentSure presents a trustless, transparent, and tamper-proof solution that builds accountability, accelerates agreements, and safeguards all stakeholders

## 🌟 Core Features of RentSure
- ✅ Agreement Automation
Digitally signed rental agreements between Tenant and Landlord

Stored securely via IPFS or on-chain references

Immutable and time-stamped to prevent tampering

- ✅ Escrow-Based Deposits
Tenant deposits funds into a smart contract escrow

Funds are only released upon mutual confirmation of move-in by both parties

Reduces fraud and builds trust without intermediaries

- ✅ Conditional Payment Logic
Enables milestone-based payouts (e.g., deposit → move-in → rent cycles)

Prevents unilateral withdrawals or missed payments

- ✅ Dispute Resolution via Arbiter
Neutral third-party arbiter role

Can vote or intervene in case of conflicts

Integrated with decentralized voting or off-chain arbitration services

- ✅ Reputation System (Soulbound Tokens)
Tenants and landlords earn non-transferable SBTs based on behavior

Includes metrics like successful agreements, timely payments, and dispute frequency

SBTs act as a decentralized credit score

- ✅ Token-Gated Document Access
Sensitive documents (leases, receipts, ID verifications) accessible only to authorized wallet holders

Prevents unauthorized access and leaks

- ✅ Web3 Identity Integration
Uses wallet addresses (e.g., MetaMask) for login and identity

No need for centralized user credentials

- ✅ Audit-Friendly Transparency
All contract interactions are recorded on-chain

Facilitates clean audit trails for legal or compliance needs

## Project Structure
- `contracts/`: Smart contracts (written in Solidity via Remix)
- `frontend/`: DApp code (React, Next.js,)
- `assets/`: Screenshots, mockups, etc.
- `videos/`: Demo screen recordings
- `deployment/`: Script files and deployed addresses

## Tech Stack
- Solidity + Remix
- React / Next.js / React Native
- IPFS / Filecoin (optional)
- MetaMask / WalletConnect
- web3.js / Wagmi / RainbowKit

## How to Run Locally
1. Clone the repo  
2. `cd frontend/rentsure && npm install`  
3. `npm run dev`

## Contracts
| Contract | Address | Network |
|----------|---------|---------|
| ExampleLoan.sol | 0x... | Sonic Testnet |

## 📸 Screenshots
![Screenshot 1](./images/screenshot-1.png)

## 🎥 Demo Video
[Watch here](./videos/demo.mp4)

## Authors
- Yasira Musah (Frontend)
- Yasira Musah (Solidity)

## 📄 License
MIT or GPL-3.0
