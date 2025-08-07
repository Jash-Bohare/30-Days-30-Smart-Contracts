// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RentEscrow {
    address public landlord;
    address public tenant;
    uint public rentAmount;
    uint public depositAmount;
    bool public rentPaid;
    bool public landlordConfirmed;
    bool public tenantConfirmed;
    uint public deadline;
    bool public completed;

    event RentDeposit(address indexed tenant, uint amount);
    event LandlordConfirmed(bool landlordConfirmed);
    event TenantConfirmed(bool tenantConfirmed);
    event RentReleased(address indexed landlord, uint amount);
    event RefundIssued(address indexed tenant, uint amount);

    constructor(address _landlord, uint _rentAmount, uint _depositAmount) {
        tenant = msg.sender;
        landlord = _landlord;
        rentAmount = _rentAmount;
        depositAmount = _depositAmount;
        deadline = block.timestamp + 30 days;
    }

    modifier onlyTenant() {
        require(msg.sender == tenant, "Only tenant can call this");
        _;
    }

    modifier onlyLandlord() {
        require(msg.sender == landlord, "Only landlord can call this");
        _;
    }

    modifier notCompleted() {
        require(!completed, "Contract already completed");
        _;
    }

    function depositRent() external payable onlyTenant notCompleted {
        require(!rentPaid, "Rent already paid");
        require(msg.value == rentAmount + depositAmount, "Incorrect amount");

        rentPaid = true;

        emit RentDeposit(msg.sender, msg.value);
    }

    function confirmByLandlord() external onlyLandlord notCompleted {
        require(rentPaid, "Rent not paid yet");
        require(!landlordConfirmed, "Already confirmed");

        landlordConfirmed = true;
        emit LandlordConfirmed(true);

        if (tenantConfirmed) {
            _releaseFunds();
        }
    }

    function confirmByTenant() external onlyTenant notCompleted {
        require(rentPaid, "Rent not paid yet");
        require(!tenantConfirmed, "Already confirmed");

        tenantConfirmed = true;
        emit TenantConfirmed(true);

        if (landlordConfirmed) {
            _releaseFunds();
        }
    }

    function autoRelease() external notCompleted {
        require(rentPaid, "Rent not paid");
        require(block.timestamp >= deadline, "Deadline not reached");
        require(tenantConfirmed || landlordConfirmed, "At least one party must confirm");

        _releaseFunds();
    }

    function refundToTenant() external onlyTenant notCompleted {
        require(rentPaid, "Rent not paid yet");
        require(!landlordConfirmed, "Landlord already confirmed");
        require(block.timestamp < deadline, "Deadline already passed");

        completed = true;

        uint refundAmount = address(this).balance;
        require(refundAmount > 0, "No funds to refund");

        payable(tenant).transfer(refundAmount);
        emit RefundIssued(tenant, refundAmount);
    }

    function _releaseFunds() internal {
        require(rentPaid, "Rent not paid");
        require(!completed, "Already completed");

        completed = true;

        require(address(this).balance >= rentAmount + depositAmount, "Insufficient balance in contract");

        payable(landlord).transfer(rentAmount);
        payable(tenant).transfer(depositAmount);

        emit RentReleased(landlord, rentAmount);
        emit RefundIssued(tenant, depositAmount);
    }

    receive() external payable {
        revert("Please use depositRent()");
    }

    fallback() external payable {
        revert("Invalid function call");
    }

    function getStatus() external view returns (
        bool _rentPaid,
        bool _landlordConfirmed,
        bool _tenantConfirmed,
        uint _timeLeft,
        bool _completed
    ) {
        _rentPaid = rentPaid;
        _landlordConfirmed = landlordConfirmed;
        _tenantConfirmed = tenantConfirmed;
        _timeLeft = block.timestamp >= deadline ? 0 : deadline - block.timestamp;
        _completed = completed;
    }

    function getContractBalance() external view returns (uint) {
        return address(this).balance;
    }
}