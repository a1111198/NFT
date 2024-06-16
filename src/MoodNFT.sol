// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@OpenZeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@OpenZeppelin/contracts/utils/Base64.sol";
import {console} from "forge-std/Script.sol";

contract MoodNFT is ERC721 {
    uint256 private s_tokenCounter;
    string private s_happyImageURI;
    string private s_sadImageURI;
    enum MOOD {
        HAPPY,
        SAD
    }
    mapping(uint256 => MOOD) s_tokenIdToMood;

    constructor(
        string memory happyMoodImageURI,
        string memory sadMoodImageURI
    ) ERC721("MoodNFT", "MN") {
        s_tokenCounter = 0;
        s_happyImageURI = happyMoodImageURI;
        s_sadImageURI = sadMoodImageURI;
    }

    function safeMint() external {
        uint256 tokenCounter = s_tokenCounter;
        _safeMint(msg.sender, tokenCounter);
        s_tokenIdToMood[tokenCounter] = MOOD.HAPPY;
        s_tokenCounter = s_tokenCounter + 1;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == MOOD.HAPPY) {
            imageURI = s_happyImageURI;
        } else {
            imageURI = s_sadImageURI;
        }
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(),
                                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", "attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function flipMood(uint256 tokenId) external {
        address owner = ownerOf(tokenId);
        if (!_isAuthorized(owner, msg.sender, tokenId)) {
            revert();
        }
        if (s_tokenIdToMood[tokenId] == MOOD.HAPPY) {
            s_tokenIdToMood[tokenId] = MOOD.SAD;
        } else {
            s_tokenIdToMood[tokenId] = MOOD.HAPPY;
        }
    }
}
