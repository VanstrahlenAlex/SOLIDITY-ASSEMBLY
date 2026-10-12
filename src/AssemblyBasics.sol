// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

/// @title AssemblyBasics - Core Assembly (Yul) Operations
/// @author Alexander Van strahlen
/// @notice Learn the fundamental EVM opcodes through inline assembly.
///
/// =================================================================
/// WHAT IS INLINE ASSEMBLY (YUL)?
/// =================================================================
///
/// Solidity compiles to EVM bytecode, but sometimes you want direct
/// control over the EVM. Inline assembly lets you write "Yul" code
/// inside Solidity functions using the `assembly { ... }` block.
///
/// WHY USE IT?
///   1. Gas optimization - skip Solidity's safety checks when you know
///      the operation is safe
///   2. Access EVM features Solidity doesn't expose (e.g., raw storage
///      slots, specific opcodes like extcodesize, coinbase, etc.)
///   3. Understand how Solidity works under the hood
///
/// THE EVM HAS 3 DATA LOCATIONS:
///   - Stack:   Temporary values during computation (max 1024 items)
///   - Memory:  Temporary byte array, erased between external calls
///   - Storage: Persistent key-value store (256-bit key -> 256-bit value)
///
/// IMPORTANT: Assembly bypasses Solidity's safety features (overflow
/// checks, bounds checking, etc.). Use it carefully!
///
contract AssemblyBasics {

	//================================================================
	//SECTION 1: STORAGE - Persistent Data (sstore / sload)
	//================================================================
	/// @notice Store a value at a specific storage slot
	/// @dev 'sstore(slot, value)' writes 'value' to storage 'slot'. 
	/// In Solidity, each state variable gets a slot automatically.
	/// With assembly, you can write to ANY slot directly.
	///
	/// Gas cost: ~20,000 for first write to a slot, ~5,000 for updates

	function store (uint256 slot, uint256 value) external {
		assembly {
			sstore(slot, value)
		}
	}

	function load (uint256 slot) external view returns (uint256 result){
		
		assembly {
			result := sload(slot)
		}
	}
}
