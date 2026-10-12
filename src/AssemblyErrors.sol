// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

/// @title AssemblyErrors - Error Handling and Control Flow in Assembly
/// @author Alexander Van strahlen
/// @notice Learn how reverts, requires, and overflow checks work at the EVM level.
///
/// =================================================================
/// HOW ERRORS WORK UNDER THE HOOD
/// =================================================================
///
/// When Solidity does `require(condition, "message")`, it compiles to:
///    1. Check the condition
///    2. If false, encode an Error(string) and call `revert(offset, size)`
///
/// The `revert(offset, size)` opcode:
///    - Stops execution
///    - Reverts all state changes
///    - Returns `size` bytes of data starting at memory `offset`
///    - The returned data is the error message (ABI encoded)
///
/// Error(string) ABI encoding:
///    [0x08c379a0] [offset=32] [length] [string bytes...]
///    ^selector    ^ABI encoding of the string parameter
///
/// Custom errors (e.g., `error Overflow()`) use their own 4-byte selector
/// and are more gas-efficient because they skip string encoding.
///
contract AssemblyErrors {

	// ----- Custom Errors --------------------------------
	error Overflow();
	error ConditionFailed();

	// ================================================================
	// SECTION 1: REVERT WITH ERROR STRING
	// ================================================================

	/// @notice Revert with a custom Error(string) message, built manually in assembly
	/// @dev This does the same thing as `revert("Some error message")` but shows
	/// how the ABI encoding works step by step.
	///
	/// Memory layout for Error(string):
	///   0x00: 0x08c379a0     (Error(string) selector)
	///   0x04: 0x20           (offset to string data = 32)
	///   0x24: length         (string byte length)
	///   0x44: string data    (padded to 32 bytes)
	function revertWithMessage() external pure {
		assembly {
			// Store the Error(string) selector at position 0x00
			// We store it as a full 32-byte word, so the selector occupies bytes 0-3
			mstore(0x00, 0x08c379a000000000000000000000000000000000000000000000000000000000)
			// Offset to string data (32 = 0x20)
			mstore(0x04, 0x20)
			// String length (14 bytes - "Assembly error")
			mstore(0x24, 14)
			// String data: "Assembly error"
			mstore(0x44, 0x417373656d626c79206572726f72000000000000000000000000000000000000)
			// Revert with 100 bytes of data (4 + 32 + 32 + 32)
			revert(0x00, 0x64)
		}
	}

}
