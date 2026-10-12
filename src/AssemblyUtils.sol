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


	
}
