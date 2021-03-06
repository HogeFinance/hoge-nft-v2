var Mint = artifacts.require("HogeNFT");
var BatchMint = artifacts.require("HogeBatchMint");

module.exports = function(deployer) {
    deployer.deploy(Mint, "Hoge Foundation Mint", "HOGEMNT", "https://www.hogemint.com/uri/");
    deployer.deploy(BatchMint, "https://www.hogemint.com/uri/");
};
