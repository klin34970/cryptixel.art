const { ethers, upgrades } = require("hardhat");

async function main() {
    const Cyclops = await ethers.getContractFactory("Cyclops");
    const Proxy = await upgrades.deployProxy(Cyclops, [], {
        initializer: "initialize",
    });
    await Proxy.deployed();
    console.log("Proxy deployed to:", Proxy.address);
}
main();