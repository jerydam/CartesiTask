// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract SoulbondToken is ERC1155, Ownable {
    // Token ID for the soulbound token
    uint256 public constant SOULBOUND_TOKEN_ID = 1;

    // Mapping to track whether an address has already minted the soulbound token
    mapping(address => bool) private hasMintedSoulboundToken;

    // Modifier to check if the sender has not minted the soulbound token
    modifier onlyNonMintedSoulboundToken() {
        require(!hasMintedSoulboundToken[msg.sender], "You have already minted the soulbound token");
        _;
    }

    constructor() ERC1155("QmQrsXCSHY1RCkPCzvc5AFNtVG1jbbh1WVseyfVrgDGuXD") Ownable(msg.sender) {
        // Mint the soulbound token to the contract creator (deployer)
        _mint(msg.sender, SOULBOUND_TOKEN_ID, 1, "");
        hasMintedSoulboundToken[msg.sender] = true;
    }

    // Function to mint the soulbound token
    function mintSoulboundToken(uint256 amount) external onlyNonMintedSoulboundToken {
        _mint(msg.sender, SOULBOUND_TOKEN_ID, amount, "");

        // Update state variables or perform additional actions
        hasMintedSoulboundToken[msg.sender] = true;
    }

    // Function to transfer other tokens, only callable by the owner
    function transfer(address token, address to, uint256 amount) external onlyOwner {
        // Ensure the token is not the soulbound token
        require(token != address(this), "Cannot transfer the soulbound token");

        // Ensure the sender has the soulbound token
        require(hasMintedSoulboundToken[msg.sender], "Sender must own the soulbound token");

        // Ensure the recipient has the soulbound token
        require(hasMintedSoulboundToken[to], "Recipient must own the soulbound token");

        ERC20(token).transfer(to, amount);
    }

    // Function to check if an address has minted the soulbound token
    function hasMinted(address account) external view returns (bool) {
        return hasMintedSoulboundToken[account];
    }
} 
