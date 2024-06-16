// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/Script.sol";
import {DeployNFT} from "../../script/DeployNFT.s.sol";
import {BasicNFT} from "../../src/BasicNft.sol";

contract BasicNFTTest is Test {
    BasicNFT basicNFT;
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    address ALICE = makeAddr("alice");

    function setUp() public {
        DeployNFT deployNFT = new DeployNFT();
        basicNFT = deployNFT.run();
    }

    function testNameOfNFT() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNFT.name();
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testSymbolOfNFT() public view {
        string memory expectedName = "DOG";
        string memory actualName = basicNFT.symbol();
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveBalance() public {
        //Arrange
        uint256 initialBalance = basicNFT.balanceOf(ALICE);
        uint256 tokenId = basicNFT.getTokenId();
        vm.prank(ALICE);
        console.log(ALICE);
        //Act
        basicNFT.mintNFT(PUG_URI);
        uint256 afterBalance = basicNFT.balanceOf(ALICE);
        // Assert
        assert(initialBalance + 1 == afterBalance);
        assert(
            keccak256(abi.encodePacked(basicNFT.tokenURI(tokenId))) ==
                keccak256(abi.encodePacked(PUG_URI))
        );
    }
}
