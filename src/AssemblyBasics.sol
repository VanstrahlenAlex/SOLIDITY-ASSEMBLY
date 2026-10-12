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


	//================================================================
	//SECTION 2: ARITHMETIC - Math Operations
	//================================================================
	//
	// These opcodes operate on 256-bit unsigned integers.
	// IMPORTANT: Unlike Solidity 0.8+, assembly arithmetic does NOT
	// revert on overflow! It wraps around silently (modular aritmetic).abi

	function assemblyAdd(uint256 a, uint256 b) external pure returns (uint256 result) {
		assembly {
			result := add(a, b)
		}
	}

	function assemblySub(uint256 a, uint256 b) external pure returns (uint256 result) {
		assembly {
			result := sub(a, b)
		}
	}

	function assemblyMul(uint256 a, uint256 b) external pure returns (uint256 result) {
		assembly {
			result := mul(a, b)
		}
	}

	function assemblyDiv(uint256 a, uint256 b) external pure returns (uint256 result) {
		assembly {
			result := div(a, b)
		}
	}

	function assemblyMod(uint256 a, uint256 b) external pure returns (uint256 result) {
		assembly {
			result := mod(a, b)
		}
	}


	// ================================================================
	// SECTION 3: BITWISE OPERATIONS
	// ================================================================
	//
	// The EVM works with 256-bit words. Bitwise operations are extremely
	// gas-efficient (3 gas each) and are the foundation of:
	//   - Packing multiple values into one storage slot
	//   - Permission systems (bitmasks)
	//   - Efficient flag checking
	//

	/// @notice Bitwise AND: a & b
	/// @dev Each bit is 1 only if BOTH corresponding bits are 1.
	/// Common use: masking - extract specific bits from a value.
	/// Example: 0xFF & 0x0F = 0x0F (extract lower 4 bits)
	function bitwiseAnd(uint256 a, uint256 b) external pure returns (uint256 result) {
		assembly {
			result := and(a, b)
		}
	}

	/// @notice Bitwise OR: a | b
	/// @dev Each bit is 1 if EITHER corresponding bit is 1.
	/// Common use: merging flags - set bits to 1 without affecting others.
	/// Example: 0xF0 | 0x0F = 0xFF (set all lower 8 bits)
	function bitwiseOr(uint256 a, uint256 b) external pure returns (uint256 result) {
		assembly {
			result := or(a, b)
		}
	}

	/// @notice Bitwise XOR: a ^ b
	/// @dev Each bit is 1 if the bits are DIFFERENT.
	/// Common use: toggling - flip bits (0→1, 1→0). XORing twice restores original.
	/// Example: 0xFF ^ 0x0F = 0xF0 (flip lower 4 bits)
	function bitwiseXor(uint256 a, uint256 b) external pure returns (uint256 result) {
		assembly {
			result := xor(a, b)
		}
	}

	/// @notice Bitwise NOT: ~a
	/// @dev Flips all bits (0→1, 1→0). In 256-bit context, this is 0xFF..FF - a.
	/// Example: ~0x00..01 = 0xFF..FE
	function bitwiseNot(uint256 a) external pure returns (uint256 result) {
		assembly {
			result := not(a)
		}
	}

	/// @notice Bitwise NOT (alternative): NOT using 'not' opcode
	/// @dev Same as bitwiseNot but using arithmetic: (0xFF..FF - a).
	/// Shows you can implement bitwise logic using arithmetic if needed.
	function bitwiseNotAlt(uint256 a) external pure returns (uint256 result) {
		assembly {
			// 0xFF...FF in 256-bit
			let allOnes := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			result := sub(allOnes, a)
		}
	}

	/// @notice Bitwise NOT: ~a (using xor with all ones)
	/// @dev Another way to compute bitwise NOT: a XOR 0xFF..FF.
	/// Demonstrates flexibility in implementing bitwise operations.
	function bitwiseNotAlt2(uint256 a) external pure returns (uint256 result) {
		assembly {
			let allOnes := 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
			result := xor(a, allOnes)
		}
	}

	/// @notice Bitwise Left Shift: a << n
	/// @dev Shifts bits of 'a' left by 'n' positions. Vacated bits filled with 0.
	/// Equivalent to multiplying by 2^n (if no overflow).
	/// Example: (0x01 << 3) = 0x08 (1 shifted left 3 times)
	function bitwiseLeftShift(uint256 a, uint256 n) external pure returns (uint256 result) {
		assembly {
			result := shl(n, a)
		}
	}

	/// @notice Bitwise Right Shift: a >> n
	/// @dev Shifts bits of 'a' right by 'n' positions. Vacated bits filled with 0.
	/// Equivalent to integer division by 2^n.
	/// Example: (0x08 >> 3) = 0x01 (8 shifted right 3 times)
	function bitwiseRightShift(uint256 a, uint256 n) external pure returns (uint256 result) {
		assembly {
			result := shr(n, a)
		}
	}

	/// @notice Bitwise Shift Left (alternative): using multiplication
	/// @dev Implementing left shift using multiplication by powers of 2.
	/// Note: 'shl' opcode is more efficient and gas-cheaper than multiplication.
	function bitwiseLeftShiftAlt(uint256 a, uint256 n) external pure returns (uint256 result) {
		assembly {
			// This is NOT equivalent to 'shl' due to overflow behavior!
			// 'shl' truncates to 256 bits, multiplication wraps around.
			// But it demonstrates an alternative conceptual approach.
			let multiplier := exp(2, n)
			result := mul(a, multiplier)
		}
	}

	/// @notice Bitwise Shift Right (alternative): using division
	/// @dev Implementing right shift using division by powers of 2.
	/// Note: 'shr' is generally more efficient.
	/// This also handles negative numbers differently (two's complement vs C-style).
	function bitwiseRightShiftAlt(uint256 a, uint256 n) external pure returns (uint256 result) {
		assembly {
			// This is NOT equivalent to 'shr' for negative numbers
			// (unsigned vs two's complement behavior).
			// But for positive numbers, it demonstrates the division concept.
			let divisor := exp(2, n)
			result := div(a, divisor)
		}
	}

	///=========== 
	/// End
	///=========== 
}
