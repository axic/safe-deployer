// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGnosisSafe {
    function setup(
        address[] memory _owners,
        uint256 _threshold,
        address to,
        bytes memory data,
        address fallbackHandler,
        address paymentToken,
        uint256 payment,
        address payable paymentReceiver
    ) external;
}

interface IGnosisSafeProxyFactory {
    function createProxyWithNonce(
        address _singleton,
        bytes memory initializer,
        uint256 saltNonce
    ) external returns (address proxy);
}

interface IOwnerManager {
    function getThreshold() external view returns (uint256);
    function getOwners() external view returns (address[] memory);
}

library SafeDeployer {
    function deploy(address[] memory owners, uint256 threshold) internal returns (address safe) {
        // Values of Safe 1.3.0.
        address safeFactory = 0xa6B71E26C5e0845f74c812102Ca7114b6a896AB2;
        address singleton = 0xd9Db270c1B5E3Bd161E8c8503c55cEABeE709552;
        address fallbackHandler = 0xf48f2B2d2a534e402487b3ee7C18c33Aec0Fe5e4;

        // The nonce seems to be timestamp in milliseconds.
        uint256 nonce = block.timestamp * 1000;

        // This will create a proxy with the list of owners and the voting threshold.
        safe = IGnosisSafeProxyFactory(safeFactory).createProxyWithNonce(
            singleton,
            abi.encodeCall(IGnosisSafe.setup, (
                owners,
                threshold,
                address(0),
                hex"",
                fallbackHandler,
                address(0),
                0,
                payable(0)
            )),
            nonce
        );

        // Add safety check.
        require(IOwnerManager(safe).getThreshold() == threshold);
    }
}
