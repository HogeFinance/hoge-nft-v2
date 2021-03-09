// test/Box.test.js
// Load dependencies
const { expect } = require('chai');

// Import utilities from Test Helpers
const { BN, expectEvent, expectRevert, constants } = require('@openzeppelin/test-helpers');

// Load compiled artifacts
const HogeNFT = artifacts.require('HogeNFT');

// Start test block
contract('HogeNFT', function ([ creator, other, holder ]) {

    // Use large integers ('big numbers')
    const value = new BN('42');

    const name = 'HogeNFT';
    const symbol = 'NFT';
    const baseURI = 'https://example.com/token/';


    beforeEach(async function () {
        this.token = await HogeNFT.new(name, symbol, baseURI, { from: creator });
    });

    it('has metadata', async function () {
        expect(await this.token.name()).to.be.equal(name);
        expect(await this.token.symbol()).to.be.equal(symbol);
        expect(await this.token.baseURI()).to.be.equal(baseURI);
    });

    it('minter can mint', async function () {
        const tokenIdZero = new BN('0');

        const receipt = await this.token.mint(holder, { from: creator });

        expect(await this.token.ownerOf(tokenIdZero)).to.be.equal(holder);
        expect(await this.token.tokenURI(tokenIdZero)).to.be.equal(`${baseURI}${tokenIdZero}`);
        expectEvent(receipt, 'Transfer', { from: constants.ZERO_ADDRESS, to: holder, tokenId: tokenIdZero });
    });

    it('non minter cannot mint', async function () {
        // Test a transaction reverts
        await expectRevert(
            this.token.mint(holder, { from: other }),
            'ERC721PresetMinterPauserAutoId: must have minter role to mint.'
        );
    });
    it("get the size of the contract", function() {
        return HogeNFT.deployed().then(function (instance) {
            var bytecode = instance.constructor._json.bytecode;
            var deployed = instance.constructor._json.deployedBytecode;
            var sizeOfB = bytecode.length / 2;
            var sizeOfD = deployed.length / 2;
            console.log("size of bytecode in bytes = ", sizeOfB);
            console.log("size of deployed in bytes = ", sizeOfD);
            console.log("initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
        });
    })
});
