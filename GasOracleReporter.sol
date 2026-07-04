// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title GasOracleReporter
 * @dev On-chain registry to store gas metric benchmarks for consuming smart contracts.
 */
contract GasOracleReporter is Ownable {

    uint256 public fastPriorityFeeGwei;
    uint256 public latestReportedTimestamp;
    address public authorizedRelayer;

    event GasMetricsUpdated(uint256 priorityFee, uint256 updatedTime);

    constructor(address _relayer) Ownable(msg.sender) {
        authorizedRelayer = _relayer;
    }

    /**
     * @notice Pushes fresh off-chain gas parameters to the on-chain directory.
     */
    function updateGasMetrics(uint256 priorityFee) external {
        require(msg.sender == authorizedRelayer, "AuthError: Caller identity matches no whitelisted relayer profiles");
        
        fastPriorityFeeGwei = priorityFee;
        latestReportedTimestamp = block.timestamp;

        emit GasMetricsUpdated(priorityFee, block.timestamp);
    }
}
