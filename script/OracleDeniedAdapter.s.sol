// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {OracleDeniedAdapter} from "../src/OracleDeniedAdapter.sol";

contract DeployOracleDeniedAdapter is Script {
    address sanctionsListAddress;

    OracleDeniedAdapter public oracleDeniedAdapter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        sanctionsListAddress = vm.envAddress("SANCTIONS_LIST_ADDRESS");
        console.log("SANCTIONS_LIST_ADDRESS: ", sanctionsListAddress);

        oracleDeniedAdapter = new OracleDeniedAdapter(sanctionsListAddress);

        vm.stopBroadcast();
    }
}
