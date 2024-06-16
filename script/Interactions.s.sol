// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DeployNFT} from "./DeployNFT.s.sol";
import {BasicNFT} from "../src/BasicNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {DeployMoodNFT} from "./DeployMoodNFT.s.sol";
import {MoodNFT} from "../src/MoodNFT.sol";

contract MintBasicNFT is Script {
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment(
            "BasicNFT",
            block.chainid
        );
        mintNFTonContract(contractAddress);
    }

    function mintNFTonContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNFT basicNFT = BasicNFT(contractAddress);
        basicNFT.mintNFT(PUG_URI);
        vm.stopBroadcast();
    }
}

contract MintMoodNFT is Script {
    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment(
            "MoodNFT",
            block.chainid
        );
        mintMoodNFTonContract(contractAddress);
    }

    function mintMoodNFTonContract(address contractAddress) public {
        vm.startBroadcast();

        MoodNFT moodNFT = MoodNFT(contractAddress);
        moodNFT.safeMint();
        vm.stopBroadcast();
    }
}

contract FlipMoodNFT is Script {
    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment(
            "MoodNFT",
            block.chainid
        );
        flipMoodNFTonContract(contractAddress);
    }

    function flipMoodNFTonContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNFT moodNFT = MoodNFT(contractAddress);
        moodNFT.safeMint();
        moodNFT.flipMood(0);
        vm.stopBroadcast();
    }
}
