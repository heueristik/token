// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {Upgrades} from "@openzeppelin/foundry-upgrades/Upgrades.sol";

import {Test} from "forge-std/Test.sol";

contract Token is ERC20Upgradeable, UUPSUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) external initializer {
        __Token_init(initialOwner);
    }

    function __Token_init(address initialOwner) internal onlyInitializing {
        __Context_init_unchained();
        __ERC20_init_unchained("Token", "TOK");
        __UUPSUpgradeable_init_unchained();

        __Token_init_unchained(initialOwner);
    }

    function __Token_init_unchained(address initialOwner) internal onlyInitializing {
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
    Token internal _tokenProxy;

    function setUp() public {
        (, _defaultSender,) = vm.readCallers();

        // Deploy proxy and mint tokens for the `_defaultSender`.
        vm.prank(_defaultSender);
        _tokenProxy = Token(
            Upgrades.deployUUPSProxy({
                contractName: "Token.sol:Token",
                initializerData: abi.encodeCall(Token.initialize, _defaultSender)
            })
        );
    }

    function test_balance() public view {
        assertEq(_tokenProxy.balanceOf(_defaultSender), 100);
    }
}
