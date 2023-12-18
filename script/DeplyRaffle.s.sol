// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";

contract DeployRaffle is Script {
    Raffle raffle;

    function run() external returns (Raffle) {
        vm.startBroadcast();

        raffle = new Raffle();
        vm.stopBroadcast();

        return raffle;
    }
}
