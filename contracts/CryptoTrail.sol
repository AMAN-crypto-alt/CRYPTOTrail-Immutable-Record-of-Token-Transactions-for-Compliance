// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CryptoTrail {
    address public admin;

    struct TransactionRecord {
        address sender;
        address receiver;
        uint256 amount;
        uint256 timestamp;
    }

    TransactionRecord[] public records;

    event TransactionLogged(address indexed sender, address indexed receiver, uint256 amount, uint256 timestamp);

    constructor() {
        admin = msg.sender;
    }

    function logTransaction(address _receiver, uint256 _amount) external {
        TransactionRecord memory newRecord = TransactionRecord({
            sender: msg.sender,
            receiver: _receiver,
            amount: _amount,
            timestamp: block.timestamp
        });

        records.push(newRecord);
        emit TransactionLogged(msg.sender, _receiver, _amount, block.timestamp);
    }

    function getTransaction(uint256 index) external view returns (TransactionRecord memory) {
        require(index < records.length, "Invalid index");
        return records[index];
    }

    function totalTransactions() external view returns (uint256) {
        return records.length;
    }

    function updateAdmin(address newAdmin) external {
        require(msg.sender == admin, "Only admin can update");
        admin = newAdmin;
    }
}
