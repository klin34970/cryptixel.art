const { ethers, upgrades} = require("hardhat");
const { expect } = require("chai");

describe("Token contract", function () {

    let Token;
    let hardhatToken;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        Token = await ethers.getContractFactory("Cyclops");
        const Proxy = await upgrades.deployProxy(Token, [], {
            initializer: "initialize",
        });
        await Proxy.deployed();
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        hardhatToken = await Proxy.deployed();
        await hardhatToken.unpause();
    });

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            expect(await hardhatToken.owner()).to.equal(owner.address);
        });
    });

    describe("Purchase", function () {
        it("Should", async function () {
            for(i= 1; i <= 10; i++){
                let buy = await hardhatToken.buy(1, [{name:'health', index:Math.floor(Math.random() * 100)},{name:'agility', index:Math.floor(Math.random() * 100)}], {value: 0.000175*10**18});
                // buy = await buy.wait();
                // const event = buy.events?.find(event => event.event === 'Properties')
                // console.log(event?.args[0][0]);
                let tokenId = await hardhatToken.getTokenIdCounter()
                console.log(tokenId);
            }
            await hardhatToken.setProperties(1, []);
            let properties = await hardhatToken.getProperties(1);
                console.log(properties);

        });
    });

});