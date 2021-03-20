# Hoge Non-Fungible Tokens
This github repo is for Hoge Foundation NFT work on the Ethereum blockchain ONLY.
LVL2 Solutions and dapp NFT work is elsewhere.

Official Website: https://www.hogemint.com

# Genesis Foundation Mint
* Compiled from this commit hash: 
  * af07cde3d467bd30bf7bdef1db7f652288547196
* Deployed contract address: 
  * https://etherscan.io/address/0x624f36C23b63F574565e9c60903ed765364566d1
  
 ## Bug Report
 * There is a bug in the foundation mint solidity code, seen here. https://github.com/hogeman-hoges/hoge-nft/blob/849685e6235c94c30a6433a2432a579a7001df75/contracts/HogeNFT.sol#L45
 * Memory type of `uris[]` should be `memory` and not `storage`
