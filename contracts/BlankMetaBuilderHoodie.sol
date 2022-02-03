//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import "./ERC721A.sol";

contract BlankMetaBuilderHoodie is ERC721A, Ownable {
    using SafeMath for uint256;
    uint256 tokenPrice = 0.2 ether;
    uint256 maxSupply = 500;
    uint256 maxPerTx = 10;

    event PriceChanged(uint256 price);

    constructor() ERC721A("BlankMetaBuilderHoodie", "HOODIE", 10) {}

    function mint(uint256 amount) payable external {
        require(tx.origin == msg.sender, "The caller is another contract");
        require(msg.value >= amount.mul(tokenPrice), "Not enough ether sent");
        require(amount <= maxPerTx, "No more than 10 per tx");
        require(totalSupply().add(amount) <= maxSupply, "No more hoodies left");
        _safeMint(msg.sender, amount);
    }

    function airdrop(address[] calldata to, uint256[] calldata amount) public onlyOwner {
        for(uint256 i = 0; i < to.length; i++) {
            require(totalSupply().add(amount[i]) <= maxSupply, "No more hoodies left");
            _safeMint(to[i], amount[i]);
        }
    }

    function setPrice(uint256 _newPrice) external onlyOwner {
        tokenPrice = _newPrice;
        emit PriceChanged(tokenPrice);
    }
    
    function withdrawFunds() external onlyOwner {
		payable(msg.sender).transfer(address(this).balance);
	}

     function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return "ipfs://QmTm1wwZmUGxVa5Mhhye4bkoo3azWUGtnUfmEB99PoRMQZ";
    }
}