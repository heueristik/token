// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20BurnableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {ERC20PermitUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import {NoncesUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/NoncesUpgradeable.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {EIP712Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";
import {Upgrades} from "@openzeppelin/foundry-upgrades/Upgrades.sol";

import {Test} from "forge-std/Test.sol";

contract TokenV1 is ERC20Upgradeable, ERC20PermitUpgradeable, ERC20BurnableUpgradeable, UUPSUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) external virtual initializer {
        __ERC20_init("Token", "TOK");
        __ERC20Permit_init("Token");
        __ERC20Burnable_init();
        __UUPSUpgradeable_init();

        _mint(initialOwner, 100);
    }

    function _authorizeUpgrade(address newImplementation) internal pure override {
        {
            newImplementation;
        }
        // NOTE: In this MWE, anyone can upgrade. DO NOT USE IN PRODUCTION.
    }
}

contract TokenTest is Test {
    address internal _defaultSender;
    TokenV1 internal _tokenProxy;

    function setUp() public {
        (, _defaultSender,) = vm.readCallers();

        // Deploy proxy and mint tokens for the `_defaultSender`.
        vm.prank(_defaultSender);
        _tokenProxy = TokenV1(
            Upgrades.deployUUPSProxy({
                contractName: "Token.sol:TokenV1",
                initializerData: abi.encodeCall(TokenV1.initialize, _defaultSender)
            })
        );
    }

    function test_balance() public view {
        assertEq(_tokenProxy.balanceOf(_defaultSender), 100);
    }
}

contract TokenV2 is TokenV1 {
    event ExampleEvent();

    /// @custom:oz-upgrades-validate-as-initializer
    function initialize(address initialOwner) external override reinitializer(2) {
        __ERC20_init("Token", "TOK");
        __ERC20Permit_init("Token");
        __ERC20Burnable_init();
        __UUPSUpgradeable_init();

        _mint(initialOwner, 100);

        emit ExampleEvent();
    }

    /// @custom:oz-upgrades-unsafe-allow missing-initializer-call
    /// @custom:oz-upgrades-validate-as-initializer
    function initializeFromV1() external reinitializer(2) {
        emit ExampleEvent();
    }
}
