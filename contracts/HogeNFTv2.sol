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

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    constructor(string memory name, string memory symbol, string memory baseURI) public ERC721(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());

        _owner = msg.sender;

        _setBaseURI(baseURI);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function mint(address to, string memory uri) public returns (uint) {
        emit Mint(_msgSender(), to, uri);
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to mint");

        _safeMint(to, _tokenIdTracker.current());
        _setTokenURI(_tokenIdTracker.current(), uri);
        _tokenIdTracker.increment();
    }

    function mintBatch(address[] memory recipients, bytes32[] memory uri_bytes) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to mint");

        for (uint256 i = 0; i < recipients.length; i++) {
            _safeMint(recipients[i], _tokenIdTracker.current());
            _setTokenURI(_tokenIdTracker.current(), bytes32ToString(uri_bytes[i]));
            _tokenIdTracker.increment();
        }
    }

    function bytes32ToString(bytes32 x) public returns (string memory) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (uint j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }

    function burn(uint256 tokenId) public virtual {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Burn: Caller is not owner nor approved");
        _burn(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
