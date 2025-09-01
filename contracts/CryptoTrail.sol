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
function getTransactionsBySender(address _sender) external view returns (TransactionRecord[] memory) {
    uint count;
    for (uint i = 0; i < records.length; i++) {
        if (records[i].sender == _sender) {
            count++;
        }
    }

    TransactionRecord[] memory result = new TransactionRecord[](count);
    uint index;
    for (uint i = 0; i < records.length; i++) {
        if (records[i].sender == _sender) {
            result[index] = records[i];
            index++;
        }
    }
    return result;
}
function deleteTransaction(uint index) external {
    require(msg.sender == admin, "Only admin can delete");
    require(index < records.length, "Invalid index");

    records[index] = records[records.length - 1]; // replace with last
    records.pop(); // remove last
}

function logAndSend(address payable _receiver) external payable {
    require(msg.value > 0, "Must send ETH");

    TransactionRecord memory newRecord = TransactionRecord({
        sender: msg.sender,
        receiver: _receiver,
        amount: msg.value,
        timestamp: block.timestamp
    });

    records.push(newRecord);
    emit TransactionLogged(msg.sender, _receiver, msg.value, block.timestamp);

    (bool success, ) = _receiver.call{value: msg.value}("");
    require(success, "Transfer failed");
}
bool public paused;

modifier whenNotPaused() {
    require(!paused, "Contract is paused");
    _;
}

function setPaused(bool _paused) external {
    require(msg.sender == admin, "Only admin can pause");
    paused = _paused;
}

function logTransaction(address _receiver, uint256 _amount) external whenNotPaused {
    // same as before
}

}
