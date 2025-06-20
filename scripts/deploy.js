const hre = require("hardhat");

async function main() {
  const CryptoTrail = await hre.ethers.getContractFactory("CryptoTrail");
  const cryptoTrail = await CryptoTrail.deploy();

  await cryptoTrail.deployed();

  console.log(`CryptoTrail contract deployed to: ${cryptoTrail.address}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error deploying contract:", error);
    process.exit(1);
  });
