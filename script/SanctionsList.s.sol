// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SanctionsList} from "../src/SanctionsList.sol";

contract DeploySanctionsList is Script {
    SanctionsList public sanctionsList;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        sanctionsList = new SanctionsList(
            0xE4F53F8aD1EB9B8A556ccF363a2389D59447a6df
        );

        vm.stopBroadcast();

        console.log("SanctionsList deployed at:", address(sanctionsList));
    }
}
