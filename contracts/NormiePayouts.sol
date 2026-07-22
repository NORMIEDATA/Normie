// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NormiePayouts — instant ETH bounties for verified street photos (Robinhood Chain)
/// @notice Operator pushes ~$1 ETH per verified asset; max N pays per wallet per UTC day.
contract NormiePayouts {
    address public owner;
    uint256 public maxPerDay;

    mapping(address => bool) public operators;
    mapping(bytes32 => bool) public paidAsset;
    /// @dev wallet => UTC day index (timestamp / 1 days) => successful pay count
    mapping(address => mapping(uint256 => uint256)) public paidCountByDay;

    event Paid(address indexed to, uint256 amount, bytes32 indexed assetId, uint256 day);
    event OperatorUpdated(address indexed account, bool allowed);
    event MaxPerDayUpdated(uint256 maxPerDay);
    event Withdrawn(address indexed to, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    error NotOwner();
    error NotOperator();
    error AlreadyPaid();
    error DailyCap();
    error ZeroAddress();
    error ZeroAmount();
    error TransferFailed();
    error InsufficientBalance();

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier onlyOperator() {
        if (!operators[msg.sender] && msg.sender != owner) revert NotOperator();
        _;
    }

    constructor(uint256 maxPerDay_) {
        owner = msg.sender;
        operators[msg.sender] = true;
        maxPerDay = maxPerDay_ == 0 ? 3 : maxPerDay_;
    }

    receive() external payable {}

    function currentDay() public view returns (uint256) {
        return block.timestamp / 1 days;
    }

    function paysToday(address wallet) external view returns (uint256) {
        return paidCountByDay[wallet][currentDay()];
    }

    /// @notice Push ETH to a contributor for a verified asset. One pay per assetId; daily cap per wallet.
    function pay(address to, uint256 amountWei, bytes32 assetId) external onlyOperator {
        if (to == address(0)) revert ZeroAddress();
        if (amountWei == 0) revert ZeroAmount();
        if (paidAsset[assetId]) revert AlreadyPaid();

        uint256 day = currentDay();
        if (paidCountByDay[to][day] >= maxPerDay) revert DailyCap();
        if (address(this).balance < amountWei) revert InsufficientBalance();

        paidAsset[assetId] = true;
        unchecked {
            paidCountByDay[to][day] += 1;
        }

        (bool ok, ) = to.call{value: amountWei}("");
        if (!ok) revert TransferFailed();

        emit Paid(to, amountWei, assetId, day);
    }

    function setOperator(address account, bool allowed) external onlyOwner {
        if (account == address(0)) revert ZeroAddress();
        operators[account] = allowed;
        emit OperatorUpdated(account, allowed);
    }

    function setMaxPerDay(uint256 maxPerDay_) external onlyOwner {
        maxPerDay = maxPerDay_;
        emit MaxPerDayUpdated(maxPerDay_);
    }

    function withdraw(address to, uint256 amount) external onlyOwner {
        if (to == address(0)) revert ZeroAddress();
        (bool ok, ) = to.call{value: amount}("");
        if (!ok) revert TransferFailed();
        emit Withdrawn(to, amount);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        if (newOwner == address(0)) revert ZeroAddress();
        address previous = owner;
        owner = newOwner;
        emit OwnershipTransferred(previous, newOwner);
    }
}
