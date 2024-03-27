// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Kwesuki is ERC721A, Ownable {
    uint256 MAX_MINTS = 100;
    uint256 MAX_SUPPLY = 10000;
    uint256 public mintRate = 0.0010 ether;

    string public baseURI = "ipfs.io/ipfs/HASH_HERE/{id}.json";

    constructor() ERC721A("Kwesuki", "KWSKI") Ownable(msg.sender){}

     function setMintRate(uint256 _mintRate) public onlyOwner {
        mintRate = _mintRate;
    }

    function mint(uint256 quantity) external payable {
        // _safeMint's second argument now takes in a quantity
        require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "Exceeds");
        require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens...");
        require(msg.value >= (mintRate * quantity), "Not enough ether sent");
        _safeMint(msg.sender, quantity);
    }

    function withdraw() external payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
      /*
    return setMintRate(uint256 _mintRate) public onlyOwner {
        mintRate = _mintRate;
    }
    */
}