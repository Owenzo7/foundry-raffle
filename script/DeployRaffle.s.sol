// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "./interactions.s.sol";

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
            uint32 callbackGasLimit,
            address link
        ) = helperconfig.activeNetworkConfig();

        if (subscriptionId == 0) {
            // we are going to need to create a subscription!
            CreateSubscription createSubscription = new CreateSubscription();

            subscriptionId = createSubscription.createSubscription(vrfCoordinator);

            // Fund it!
            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription.fundSubscription(vrfCoordinator, subscriptionId, link);
        }

        vm.startBroadcast();
        raffle = new Raffle(entranceFee, interval, vrfCoordinator, gasLane, subscriptionId, callbackGasLimit);

        vm.stopBroadcast();

        AddConsumer addconsumer = new AddConsumer();
        addconsumer.addConsumer(address(raffle), vrfCoordinator, subscriptionId);

        return (raffle, helperconfig);
    }
}
