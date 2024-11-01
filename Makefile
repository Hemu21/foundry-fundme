-include .env

# Clean the repo
clean  :; forge clean

install :; forge install cyfrin/foundry-devops --no-commit && forge install smartcontractkit/chainlink-brownie-contracts --no-commit && forge install foundry-rs/forge-std --no-commit

# Update Dependencies
update:; forge update

build:; forge build

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil

deploy-anvil:; forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://localhost:8545 --private-key $(ANVIL_PRIVATE_KEY) --broadcast -vvvv


deploy-sepolia:; forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv