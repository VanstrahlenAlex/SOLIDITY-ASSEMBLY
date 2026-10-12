// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// @title AssemblyUtils - Practical Assembly Patterns
/// @author Alexander Van strahlen
/// @notice Real-world use cases where assembly gives you capabilities
/// or gas savings that pure Solidity cannot match.
///
/// =================================================================
/// WHY USE ASSEMBLY IN PRACTICE?
/// =================================================================
///
/// 1. ACCESS EVM-ONLY FEATURES:
///    - `extcodesize` - check if address is a contract
///    - `balance` - get ETH balance without interface
///    - `caller`, `origin` - message sender context
///    - `coinbase`, `timestamp`, `number` - block info
///
/// 2. GAS OPTIMIZATION:
///    - Pack/unpack multiple values in one storage slot
///    - Avoid ABI encoding overhead for hashing
///    - Skip unnecessary checks when you know data is valid
///
/// 3. LOW-LEVEL CONTROL:
///    - Manual memory management
///    - Custom ABI encoding/decoding
///    - Delegate calls with precise control
///
contract AssemblyUtils {

	// ================================================================
	// SECTION 1: ENVIRONMENT INFORMATION
	// ================================================================

	function getBalance(address addr) external view returns (uint256 bal) {
		assembly {
			bal := balance(addr)
		}
	}

	function getCodeSize(address addr) external view returns (uint256 size) {
		assembly {
			size := extcodesize(addr)
		}
	}

	function isContract(address addr) external view returns (bool result) {
		assembly {
			result := gt(extcodesize(addr), 0)
		}
	}

	function getCallerAndOrigin() external view returns (address msgSender, address txOrigin) {
		assembly {
			msgSender := caller()
			txOrigin := origin()
		}
	}

	// ================================================================
	// SECTION 2: EFFICIENT HASHING
	// ================================================================

	/// @notice Hash bytes data using keccak256 in assembly
	/// @dev `keccak256(offset, size)` hashes `size` bytes starting at `offset` in memory.
	///
	/// In Solidity: `keccak256(abi.encodePacked(data))` first copies data to memory,
	/// then hashes. In assembly, if data is already in memory (like calldata),
	/// we can hash it directly, saving gas on the copy step.
	///
	/// Here we hash two uint256 values packed together (64 bytes total).
	function efficientHash(uint256 a, uint256 b) external pure returns (bytes32 result) {
		assembly {
			// Use scratch space (0x00-0x3F) for hashing - Solidity reserves this area
			mstore(0x00, a)    // Store `a` at memory position 0x00 (32 bytes)
			mstore(0x20, b)    // Store `b` at memory position 0x20 (32 bytes)
			result := keccak256(0x00, 0x40) // Hash 64 bytes starting at 0x00
		}
	}

	
}
