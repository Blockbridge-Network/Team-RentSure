// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {KRNL, KrnlPayload, KernelParameter, KernelResponse} from "./KRNL.sol";

contract RentalAgreement is KRNL {

    struct Agreement {
        uint256 id;
        address landlord;
        address tenant;
        string propertyAddress;
        uint256 rentAmount;
        bool landlordConfirmed;
        bool tenantConfirmed;
        bool isDisputed;
        bool isResolved;
    }

    uint256 public nextAgreementId;
    address public arbiter; // Arbiter address
    mapping(uint256 => Agreement) public agreements;
    mapping(address => uint256[]) public userAgreements;
    mapping(uint256 => uint256) public deposits; // Tracks deposits for each agreement

    event AgreementCreated(uint256 id, address indexed landlord, address indexed tenant, string propertyAddress, uint256 rentAmount);
    event MoveInConfirmed(uint256 id, address indexed user);
    event DisputeRaised(uint256 id, address indexed user);
    event DisputeResolved(uint256 id, string resolution, address indexed arbiter);
    event FundsTransferred(uint256 id, address indexed recipient, uint256 amount);
    event Broadcast(address indexed sender, uint256 score, string input);

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Only the arbiter can perform this action");
        _;
    }

    // constructor(address _arbiter) {
    //     arbiter = _arbiter;
    // }

    constructor(address _arbiter) KRNL(_arbiter) {
        arbiter = _arbiter;

    }

    function createAgreement(address _tenant, string memory _propertyAddress, uint256 _rentAmount) public payable {
        // require(_tenant != address(0), "Invalid tenant address");
        // require(_rentAmount > 0, "Rent amount must be greater than zero");
        // require(msg.value == _rentAmount, "Deposit must match the rent amount");

        agreements[nextAgreementId] = Agreement({
            id: nextAgreementId,
            landlord: msg.sender,
            tenant: _tenant,
            propertyAddress: _propertyAddress,
            rentAmount: _rentAmount,
            landlordConfirmed: false,
            tenantConfirmed: false,
            isDisputed: false,
            isResolved: false
        });

        deposits[nextAgreementId] = msg.value;

        userAgreements[msg.sender].push(nextAgreementId);
        userAgreements[_tenant].push(nextAgreementId);

        emit AgreementCreated(nextAgreementId, msg.sender, _tenant, _propertyAddress, _rentAmount);

        nextAgreementId++;
    }

    function confirmMoveIn(uint256 _agreementId) public {
        Agreement storage agreement = agreements[_agreementId];
        require(msg.sender == agreement.landlord || msg.sender == agreement.tenant, "Only landlord or tenant can confirm move-in");
        require(!agreement.isResolved, "Agreement is already resolved");

        if (msg.sender == agreement.landlord) {
            agreement.landlordConfirmed = true;
        } else if (msg.sender == agreement.tenant) {
            agreement.tenantConfirmed = true;
        }

        emit MoveInConfirmed(_agreementId, msg.sender);

        // If both parties confirm, transfer funds to the landlord
        if (agreement.landlordConfirmed && agreement.tenantConfirmed) {
            uint256 amount = deposits[_agreementId];
            deposits[_agreementId] = 0;
            payable(agreement.landlord).transfer(amount);
            agreement.isResolved = true;

            emit FundsTransferred(_agreementId, agreement.landlord, amount);
        }
    }

    function raiseDispute(uint256 _agreementId) public {
        Agreement storage agreement = agreements[_agreementId];
        require(msg.sender == agreement.landlord || msg.sender == agreement.tenant, "Only landlord or tenant can raise a dispute");
        require(!agreement.isResolved, "Agreement is already resolved");

        agreement.isDisputed = true;

        emit DisputeRaised(_agreementId, msg.sender);
    }

    function resolveDispute(uint256 _agreementId, address _recipient) public onlyArbiter {
        Agreement storage agreement = agreements[_agreementId];
        require(agreement.isDisputed, "No dispute to resolve");
        require(!agreement.isResolved, "Agreement is already resolved");

        uint256 amount = deposits[_agreementId];
        deposits[_agreementId] = 0;
        payable(_recipient).transfer(amount);
        agreement.isResolved = true;

        emit DisputeResolved(_agreementId, "Dispute resolved by arbiter", msg.sender);
        emit FundsTransferred(_agreementId, _recipient, amount);
    }

    
function protectedFunction(
    uint256 _agreementId,
    KrnlPayload memory krnlPayload,
    string memory input
)
    external
    onlyAuthorized(krnlPayload, abi.encode(input)) // Ensures only authorized calls
{
    Agreement storage agreement = agreements[_agreementId];
    require(!agreement.isResolved, "Agreement is already resolved");

    // Decode kernel responses
    KernelResponse[] memory kernelResponses = abi.decode(krnlPayload.kernelResponses, (KernelResponse[]));
    uint256 score;
    for (uint256 i = 0; i < kernelResponses.length; i++) {
        if (kernelResponses[i].kernelId == 337) {
            // Decode the result from the kernel
            score = abi.decode(kernelResponses[i].result, (uint256));
        }
    }

    // Example logic: Update agreement or perform an action based on the score
    if (score > 50) {
        agreement.isResolved = true;
        emit DisputeResolved(_agreementId, "Resolved via KRNL", msg.sender);
    } else {
        agreement.isDisputed = true;
        emit DisputeRaised(_agreementId, msg.sender);
    }

    // Emit an event with the input and score
    emit Broadcast(msg.sender, score, input);
}


// Get agreements for a specific user
    function getUserAgreements(address _user)
        public
        view
        returns (Agreement[] memory)
    {
        uint256[] memory userAgreementIds = userAgreements[_user];
        Agreement[] memory userAgreementList = new Agreement[](
            userAgreementIds.length
        );

        for (uint256 i = 0; i < userAgreementIds.length; i++) {
            userAgreementList[i] = agreements[userAgreementIds[i]];
        }

        return userAgreementList;
    }
}