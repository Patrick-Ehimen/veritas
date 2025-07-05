# Veritas Smart Contracts

> Decentralized Identity Management System with Soulbound Tokens

[![Solidity](https://img.shields.io/badge/Solidity-0.8.20-blue.svg)](https://soliditylang.org/)
[![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-5.0.2-orange.svg)](https://openzeppelin.com/)
[![Hardhat](https://img.shields.io/badge/Hardhat-2.25.0-yellow.svg)](https://hardhat.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

## 📋 Overview

Veritas is a comprehensive decentralized identity management system built on Ethereum. It provides a secure, transparent, and immutable way to manage digital identities using soulbound tokens (SBTs) and complementary smart contracts for identity verification, reputation tracking, and governance.

## 🏗️ Architecture

The system consists of four core smart contracts:

### 1. **SoulBoundToken** - Decentralized Identity Core

- **Purpose**: Issues non-transferable identity tokens representing verified digital identities
- **Type**: ERC721-based Soulbound Token
- **Features**:
  - One identity per wallet address
  - Stores personal data (identifier, birthdate, full name)
  - Non-transferable (soulbound) behavior
  - Owner-controlled issuance

### 2. **KeyManager** - Cryptographic Key Management

- **Purpose**: Generates and manages unique cryptographic keys for users
- **Features**:
  - Secure key generation using blockchain randomness
  - User registration system
  - Owner-only access control
  - Event logging for key creation

### 3. **IdentityReport** - Reputation & Compliance

- **Purpose**: Issues negative reports as soulbound NFTs for compliance tracking
- **Type**: ERC721-based Soulbound Token
- **Features**:
  - Multiple reports per user supported
  - Detailed report metadata (topic, details, organization)
  - Non-transferable negative reputation markers
  - Compliance audit trails

### 4. **Voting** - Decentralized Governance

- **Purpose**: Manages approval/rejection polls with permissioned voting
- **Features**:
  - Admin-controlled voter permissions
  - Poll lifecycle management (open/close)
  - Vote tallying (approvals vs rejections)
  - Event-driven transparency

## 🚀 Quick Start

### Prerequisites

- Node.js v18+ (Note: v23.8.0 shows Hardhat warnings but works)
- pnpm package manager
- Git

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd veritas

# Install dependencies
pnpm install

# Navigate to contracts package
cd packages/contracts
```

### Compilation

```bash
# Compile all contracts
pnpm compile

# Alternative: compile with specific filter
pnpm --filter @repo/contracts compile
```

### Testing

```bash
# Run all tests
pnpm test

# Run tests with gas reporting
REPORT_GAS=true pnpm test

# Run specific test file
pnpm test test/SoulBoundToken.ts
```

## 📁 Project Structure

```
packages/contracts/
├── contracts/
│   ├── soul-bound-token.sol      # Main identity SBT contract
│   ├── key-manager.sol           # Cryptographic key management
│   ├── negative-nft.sol          # Negative reports (IdentityReport)
│   ├── vote.sol                  # Governance voting system
│   └── Lock.sol                  # Sample contract (unused)
├── test/
│   ├── SoulBoundToken.ts         # Identity token tests
│   ├── KeyManager.ts             # Key management tests
│   ├── IdentityReport.ts         # Negative reports tests
│   ├── Voting.ts                 # Governance tests
│   └── Lock.ts                   # Sample tests
├── hardhat.config.ts             # Hardhat configuration
├── package.json                  # Dependencies and scripts
└── README.md                     # This file
```

## 🔧 Contract Details

### SoulBoundToken

```solidity
// Deploy with admin address
constructor(address admin)

// Issue new identity (owner only)
function issueIdentity(
    address recipient,
    string memory id,
    string memory dob,
    string memory name
) public onlyOwner

// Retrieve identity data (owner only)
function getIdentity(address user)
    public view onlyOwner
    returns (IdentityData memory)
```

### KeyManager

```solidity
// Register new user and generate key (owner only)
function registerUser(address user) public onlyOwner

// Fetch user's key (owner only)
function fetchKey(address user)
    public view onlyOwner
    returns (bytes32)
```

### IdentityReport

```solidity
// Issue negative report (owner only)
function issueNegativeNFT(
    address recipient,
    string memory topic,
    string memory details,
    string memory organization
) public onlyOwner

// Get all reports for account (owner only)
function getReports(address account)
    public view onlyOwner
    returns (ReportDetails[] memory)
```

### Voting

```solidity
// Grant voting permission (admin only)
function grantPermission(address voter) external onlyAdmin

// Open poll for voting (admin only)
function openPoll() external onlyAdmin

// Submit vote (permitted voters only, poll must be open)
function submitVote(bool choice) external onlyPermitted pollIsOpen

// Get current results (public)
function fetchResults()
    external view
    returns (uint256 approvals, uint256 rejections)
```

## 🧪 Testing Coverage

| Contract       | Tests       | Coverage                                              |
| -------------- | ----------- | ----------------------------------------------------- |
| SoulBoundToken | 3 tests     | Identity issuance, Access control, Soulbound behavior |
| KeyManager     | 2 tests     | User registration, Access control                     |
| IdentityReport | 2 tests     | Report issuance, Soulbound behavior                   |
| Voting         | 2 tests     | Poll management, Voting logic                         |
| **Total**      | **9 tests** | **All core features covered**                         |

### Test Results

```
✔ 9 passing (782ms)

Gas Usage:
- SoulBoundToken deployment: 2,703,394 gas (9%)
- KeyManager deployment: 511,583 gas (1.7%)
- IdentityReport deployment: 2,715,488 gas (9.1%)
- Voting deployment: 781,498 gas (2.6%)
```

## 🔒 Security Features

### Access Control

- **Owner-based permissions**: Critical functions restricted to contract owners
- **OpenZeppelin Ownable**: Industry-standard access control patterns
- **Permission validation**: Comprehensive modifier usage

### Soulbound Token Security

- **Non-transferable**: Prevents identity theft and trading
- **One identity per address**: Prevents duplicate identities
- **Immutable records**: On-chain identity persistence

### Data Integrity

- **Structured data**: Consistent data formats across contracts
- **Event logging**: Complete audit trails
- **Input validation**: Robust error handling

## 🚀 Deployment

### Local Development

```bash
# Start local Hardhat node
pnpm hardhat node

# Deploy contracts (in another terminal)
pnpm hardhat run scripts/deploy.ts --network localhost
```

### Testnet Deployment

```bash
# Deploy to Sepolia testnet
pnpm hardhat run scripts/deploy.ts --network sepolia

# Verify contracts
pnpm hardhat verify --network sepolia <contract-address>
```

## 📊 Gas Optimization

- **Efficient storage**: Optimized struct packing
- **Minimal external calls**: Reduced gas costs
- **Event-driven architecture**: Off-chain indexing friendly
- **OpenZeppelin patterns**: Battle-tested implementations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Write tests for new functionality
4. Ensure all tests pass: `pnpm test`
5. Commit changes: `git commit -m 'Add amazing feature'`
6. Push to branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

## 🐛 Known Issues

- **Node.js Warning**: Hardhat shows compatibility warnings with Node.js v23.8.0, but functionality is not affected
- **Gas Estimation**: Some operations may require manual gas limit specification on certain networks

## 📚 Additional Resources

- [OpenZeppelin Documentation](https://docs.openzeppelin.com/)
- [Hardhat Documentation](https://hardhat.org/docs)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [ERC-721 Standard](https://eips.ethereum.org/EIPS/eip-721)

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 📞 Support

For questions, issues, or contributions:

- Open an issue on GitHub
- Contact the development team
- Review the documentation

---

**Built with ❤️ for decentralized identity management**
