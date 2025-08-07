// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SplitBill {
    address public billOwner;
    uint public totalAmount;
    address[] public participants;
    mapping(address => uint) public amountOwed;
    mapping(address => uint) public amountPaid;
    uint public totalCollected;
    bool public isSettled;

    event BillCreated(address indexed owner, uint totalAmount);
    event PaymentMade(address indexed participant, uint amount);
    event BillPaidOut(uint totalAmount);

    modifier onlyOwner() {
        require(msg.sender == billOwner, "Not bill owner");
        _;
    }

    modifier onlyParticipant() {
        require(amountOwed[msg.sender] > 0, "Not a participant");
        _;
    }

    modifier billNotSettled() {
        require(!isSettled, "Bill already settled");
        _;
    }

    constructor(
        uint _totalAmount,
        address[] memory _participants,
        uint[] memory _sharePerPerson
    ) {
        require(
            _participants.length == _sharePerPerson.length,
            "Mismatch between participants and shares"
        );

        billOwner = msg.sender;
        totalAmount = _totalAmount;
        participants = _participants;

        for (uint i = 0; i < _participants.length; i++) {
            amountOwed[_participants[i]] = _sharePerPerson[i];
        }

        emit BillCreated(msg.sender, _totalAmount);
    }

    function payShare() external payable onlyParticipant billNotSettled {
        require(msg.value > 0, "No ETH sent");
        require(
            amountPaid[msg.sender] + msg.value <= amountOwed[msg.sender],
            "Overpayment not allowed"
        );

        amountPaid[msg.sender] += msg.value;
        totalCollected += msg.value;

        emit PaymentMade(msg.sender, msg.value);

        if (totalCollected == totalAmount) {
            releaseFunds();
        }
    }

    function releaseFunds() internal billNotSettled {
        isSettled = true;
        payable(billOwner).transfer(totalCollected);
        emit BillPaidOut(totalCollected);
    }

    function getParticipants() external view returns (address[] memory) {
        return participants;
    }

    function getRemainingAmount(address _participant) external view returns (uint)
    {
        return amountOwed[_participant] - amountPaid[_participant];
    }
}