var Mint = artifacts.require("HogeNFT")

module.exports = function(deployer) {
    deployer.deploy(Mint, "Hoge Foundation Mint", "HOGENFT", "https://www.hogemint.com/uri/");
};
