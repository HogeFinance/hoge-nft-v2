const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();


module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id
      accounts: 5,
      defaultEtherBalance: 500
    },

    mainnet: {
      provider: function() {
        return new HDWalletProvider(
            `${process.env.MNEMONIC}`,
            `https://mainnet.infura.io/v3/${process.env.INFURA_ID}`
        )
      },
      gas: 5000000,          // Default gas to send per transaction
      gasPrice: 90000000000,  // 90 gwei
      network_id: 1,
      skipDryRun: true
    },

    ropsten: {
      provider: function() {
        return new HDWalletProvider(
            `${process.env.MNEMONIC}`,
            `https://ropsten.infura.io/v3/${process.env.INFURA_ID}`
        )
      },
      network_id: 3
    },

    rinkeby: {
      provider: function() {
        return new HDWalletProvider(
            `${process.env.MNEMONIC}`,
            `https://rinkeby.infura.io/v3/${process.env.INFURA_ID}`
        )
      },
      network_id: 4
    },

    develop: {
      port: 8545
    }
  },
  compilers: {
    solc: {
      version: "0.7.6"  // ex:  "0.4.20". (Default: Truffle's installed solc)
    }
  },

  api_keys: {
    etherscan: process.env.ETHERSCAN_API
  },

  plugins: [
    'truffle-plugin-verify'
  ]
};
