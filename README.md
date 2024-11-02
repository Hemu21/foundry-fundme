
# FundMe - Decentralized Funding Platform

FundMe is a decentralized funding platform built using Foundry and Solidity, allowing users to fund the contract with a minimum amount of $5 USD (in ETH), using Chainlink's price feed for real-time ETH/USD conversion. This project includes testing capabilities with an Anvil local blockchain and can be deployed to the Sepolia testnet.

## Features
- **Real-time Price Feed**: Fetches the current ETH/USD price via Chainlink.
- **Minimum Funding Requirement**: Enforces a minimum funding amount of 5 USD.
- **Testing and Simulation**: Built-in tests that run with Foundry and Anvil, making it easy to test locally.
- **Deployment Ready**: Scripts for deploying on local and Sepolia testnet environments.

## Getting Started

Follow these steps to set up, build, and deploy the project.

### Prerequisites

- **Foundry**: Install [Foundry](https://book.getfoundry.sh/getting-started/installation.html) and ensure `forge`, `cast`, and `anvil` are available in your CLI.
- **Git**: [Git](https://git-scm.com/) for cloning the repository.
- **Node.js and npm** (optional): For advanced setups, especially if deploying and verifying on Etherscan.
- **Chainlink Node API key** and **Ethereum Wallet Private Key** (e.g., from MetaMask or a test account).

### Installation

1. **Clone the repository**:

   ```bash copy
   git clone https://github.com/yourusername/fundme-foundry.git
   cd fundme-foundry
   ```

2. **Install Dependencies**:

   ```bash copy
   make install
   ```

   This command installs the necessary dependencies, including:
   - [Cyfrin Foundry DevOps](https://github.com/Cyfrin/foundry-devops)
   - [Chainlink Brownie Contracts](https://github.com/smartcontractkit/chainlink-brownie-contracts)
   - [Forge Std](https://github.com/foundry-rs/forge-std)

3. **Environment Variables**:

   Create a `.env` file in the project root and add the following variables or use the .env.example:

   ```plaintext
   ANVIL_PRIVATE_KEY=<YOUR_ANVIL_PRIVATE_KEY>
   PRIVATE_KEY=<YOUR_DEPLOYMENT_PRIVATE_KEY>
   SEPOLIA_RPC_URL=<YOUR_SEPOLIA_RPC_URL>
   ETHERSCAN_API_KEY=<YOUR_ETHERSCAN_API_KEY>
   ```

   - `ANVIL_PRIVATE_KEY`: Private key for local Anvil testing.
   - `PRIVATE_KEY`: Private key for deploying on Sepolia.
   - `SEPOLIA_RPC_URL`: RPC URL for Sepolia (e.g., from Alchemy or Infura).
   - `ETHERSCAN_API_KEY`: API key for verifying the contract on Etherscan.

## Usage

### Makefile Commands

To streamline the development process, use the provided `Makefile` commands.

- **Clean the Project**:

  ```bash copy
  make clean
  ```

  Cleans the compiled artifacts and resets the project.

- **Build the Project**:

  ```bash copy
  make build
  ```

  Compiles the smart contracts.

- **Run Tests**:

  ```bash copy
  forge test
  ```

  Runs tests on the local Anvil blockchain.

- **Start Local Blockchain**:

  ```bash copy
  make anvil
  ```

  Starts an Anvil blockchain instance.

- **Deploy Locally**:

  ```bash copy
  make deploy-anvil
  ```

  Deploys the contract on a local Anvil blockchain.

- **Deploy on Sepolia Testnet**:

  ```bash copy
  make deploy-sepolia
  ```

  Deploys the contract on the Sepolia testnet with Etherscan verification.

### Running Tests

1. **Start Anvil**:

   ```bash copy
   make anvil
   ```

2. **Run Tests**:

   ```bash copy
   forge test
   ```

   This runs all tests to ensure contract functionality, such as checking minimum funding requirements and fetching accurate price feeds.

## Deployment

### Deploy to Sepolia Testnet

To deploy on Sepolia:

1. Make sure `.env` has valid `SEPOLIA_RPC_URL`, `PRIVATE_KEY`, and `ETHERSCAN_API_KEY`.
2. Run the deployment script:

   ```bash copy
   make deploy-sepolia
   ```

### Verification on Etherscan

If the deployment is successful, the script will automatically verify the contract on Etherscan. Check your contract's Etherscan page to see if verification succeeded.