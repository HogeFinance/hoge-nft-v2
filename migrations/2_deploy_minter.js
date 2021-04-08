var Mint = artifacts.require("HogeNFTv2");

module.exports = function(deployer) {
    deployer.deploy(Mint, "Hoge Foundation Mint V2", "HOGENFTv2", "https://www.hogemint.com/uri/");
};
