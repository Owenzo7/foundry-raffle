// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployRaffle is Script {
    Raffle raffle;

    function run() external returns (Raffle, HelperConfig) {
        HelperConfig helperconfig = new HelperConfig();

        (
            uint256 entranceFee,
            uint256 interval,
            address vrfCoordinator,
            bytes32 gasLane,
            uint64 subscriptionId,
            uint32 callbackGasLimit
        ) = helperconfig.activeNetworkConfig();

        vm.startBroadcast();
        raffle = new Raffle(entranceFee, interval, vrfCoordinator, gasLane, subscriptionId, callbackGasLimit);

        vm.stopBroadcast();

        return (raffle, helperconfig);
    }
}