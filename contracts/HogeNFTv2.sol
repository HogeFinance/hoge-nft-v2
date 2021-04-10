// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HogeNFTv2 is Context, AccessControl, ERC721 {
    using Counters for Counters.Counter;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    Counters.Counter private _tokenIdTracker;
    address private _owner;

    event Received(address, uint);
    event Mint(address from, address to, string uri);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    constructor(string memory name, string memory symbol, string memory baseURI) public ERC721(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());

        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);

        _setBaseURI(baseURI);
    }

    function mint(address to, string memory uri) public returns (uint) {
        emit Mint(_msgSender(), to, uri);
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to mint");

        _safeMint(to, _tokenIdTracker.current());
        _setTokenURI(_tokenIdTracker.current(), uri);
        _tokenIdTracker.increment();
    }

    function burn(uint256 tokenId) public virtual {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Burn: Caller is not owner nor approved");
        _burn(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Begin Ownable interface from openzeppelin
    // Primarily used for OpenSea storefront management, AccessControl is used for choosing who can mint.
    // Owner, MINTER_ROLE, PAUSER_ROLE can all be separate addresses!
    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function contractURI() public view returns (string memory) {
        return "https://www.hogemint.com/uri/contract-HogeNFTv2";
    }
}
