# Rebase Token Cross-Chain

A **cross-chain rebase token** implementation using **Solidity**, **Foundry**, and **Chainlink CCIP** for secure, decentralized message passing between chains.  
This project demonstrates how to create a **rebase token** that maintains supply elasticity while enabling **seamless cross-chain communication** for synchronized supply changes.

---

## 📌 Overview

This project implements:

- **Elastic supply mechanism** — token supply adjusts dynamically based on a rebase logic.
- **Cross-chain synchronization** — uses **Chainlink Cross-Chain Interoperability Protocol (CCIP)** to update token states across multiple blockchains.
- **Secure message passing** — ensures that rebase events are propagated consistently and securely between chains.
- **Gas-efficient design** — optimized Solidity contracts for minimal transaction costs.
- **Test-driven development** — built and tested using **Foundry**.

---

## 🚀 Features

- **Rebase Functionality**  
  Automatically adjusts balances of all holders proportionally when supply changes.
  
- **Cross-Chain Communication**  
  Uses Chainlink CCIP to send and receive supply update messages between supported EVM-compatible chains.
  
- **Configurable Parameters**  
  Owner-controlled rebase parameters and chain mappings.
  
- **Foundry Testing Suite**  
  Includes end-to-end tests for:
  - Local rebase
  - Cross-chain message sending
  - Cross-chain message receiving
  - Edge cases (overflows, access control)

---

## 🛠 Tech Stack

- **Language:** Solidity
- **Framework:** [Foundry](https://book.getfoundry.sh/) (`forge`, `cast`)
- **Cross-Chain:** [Chainlink CCIP](https://chain.link/cross-chain)
- **Ethereum Standards:** ERC20 with rebase extension
- **Networks:** Any EVM-compatible chain supported by CCIP (Ethereum, Polygon, Avalanche, etc.)

---

## 📂 Project Structure

```
Rebase-Token-Cross-chain/
├── src/                    # Solidity smart contracts
│   ├── RebaseToken.sol     # Main rebase token contract
│   ├── CCIPReceiver.sol    # Handles incoming CCIP messages
│   ├── CCIPSender.sol      # Sends messages to other chains
│   └── interfaces/         # Contract interfaces
├── script/                 # Deployment and interaction scripts
├── test/                   # Foundry test files
│   ├── RebaseToken.t.sol   # Unit tests for token
│   ├── CrossChain.t.sol    # Tests for CCIP integration
├── foundry.toml            # Foundry config
└── README.md               # Project documentation
```

---

## ⚙️ Installation & Setup

### 1️⃣ Install Foundry
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 2️⃣ Clone the Repository
```bash
git clone https://github.com/damesh13/Rebase-Token-Cross-chain.git
cd Rebase-Token-Cross-chain
```

### 3️⃣ Install Dependencies
```bash
forge install
```

### 4️⃣ Set Environment Variables
Create a `.env` file with:
```ini
PRIVATE_KEY=your_wallet_private_key
RPC_URL=your_rpc_url
CCIP_ROUTER_ADDRESS=ccip_router_contract_address
DEST_CHAIN_SELECTOR=chain_selector_id
```

---

## 🧪 Running Tests

Run the full Foundry test suite:
```bash
forge test -vv
```

---

## 📤 Deployment

Example deployment with Foundry:
```bash
forge script script/Deploy.s.sol   --rpc-url $RPC_URL   --private-key $PRIVATE_KEY   --broadcast
```

---

## 🔄 How Cross-Chain Rebase Works

1. **Rebase Triggered**  
   Admin calls `rebase()` on the source chain.

2. **CCIP Message Sent**  
   Contract sends a CCIP message to destination chains with updated supply info.

3. **Message Received**  
   Destination chain’s receiver contract updates its local token balances.

4. **Supply Synchronized**  
   All participating chains reflect the same proportional balances.

---

## 📜 Example Usage

**Triggering a rebase on source chain:**
```solidity
rebaseToken.rebase(int256(500)); // +5% supply
```

**Sending cross-chain rebase update:**
```solidity
rebaseToken.sendRebaseUpdate(destChainSelector, int256(500));
```

---

## 🛡 Security Notes

- Only trusted routers and addresses should be configured for CCIP communication.
- Always verify the sender in `ccipReceive` to avoid malicious messages.
- Consider rate-limiting rebases to prevent abuse.

---

## 📄 License

This project is licensed under the **MIT License**

---

## 🤝 Contributing

1. Fork the repository  
2. Create a feature branch:  
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes  
4. Push and create a PR

---

## 📬 Contact

- GitHub: [@damesh13](https://github.com/damesh13)  
- Email: *dameswararao01@gmail.com*  
