// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

/// ================================================================
/// TO RUN THESE TESTS:
///   forge test -vvv
/// ================================================================

import "forge-std/Test.sol";
import {AssemblyBasics} from "../src/AssemblyBasics.sol";
import {AssemblyUtils} from "../src/AssemblyUtils.sol";
import {AssemblyErrors} from "../src/AssemblyErrors.sol";

contract AssemblyTest is Test {
	AssemblyBasics public basics;
	AssemblyUtils public utils;
	AssemblyErrors public errors;

	function setUp() public {
		basics = new AssemblyBasics();
		utils = new AssemblyUtils();
		errors = new AssemblyErrors();
	}

	// ================================================================
	// SECTION 1: Storage Operations (sstore / sload)
	// ================================================================

	function test_storeAndLoad() public {
		basics.store(0, 42);
		uint256 value = basics.load(0);
		assertEq(value, 42, "error storing");
	}

	function test_storeDifferentSlots() public {
		basics.store(1, 100);
		basics.store(2, 200);
		basics.store(3, 300);
	}

	function test_storeOverwrite() public {
		basics.store(5, 111);
		assertEq(basics.load(5), 111, "value does not match");
		
		basics.store(5, 999);
		assertEq(basics.load(5), 999, "value does not match");
	}
}
