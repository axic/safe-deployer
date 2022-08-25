// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import {SafeDeployer} from "./SafeDeployer.sol";

contract SafeDeployerFrontend {
    function deploy(address[] memory owners, uint256 threshold) external returns (address safe) {
        return SafeDeployer.deploy(owners, threshold);
    }
}
