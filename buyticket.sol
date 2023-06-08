// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./hexagone.sol"; // Import your ERC20 token contract




contract Tickets {

    address public owner;

    Hexagone public tokenContract;

    uint256 public ticketPrice;

    uint256 public totalTickets;

    uint256 public ticketsSold;




    mapping(address => uint256) public ticketBalances;




    event TicketPurchased(address indexed buyer, uint256 quantity);




    modifier onlyOwner() {

        require(msg.sender == owner, "Only the contract owner can call this function.");

        _;

    }




    constructor(address _tokenContractAddress, uint256 _ticketPrice, uint256 _totalTickets) {

        owner = msg.sender;

        tokenContract = Hexagone(_tokenContractAddress);

        ticketPrice = _ticketPrice;

        totalTickets = _totalTickets;

        ticketsSold = 0;

    }




    function buyTickets(uint256 quantity) external {

        require(quantity > 0, "Number of tickets must be greater than zero.");

        require(ticketsSold + quantity <= totalTickets, "Insufficient tickets available.");




        uint256 cost = ticketPrice * quantity;

        require(tokenContract.allowance(msg.sender, address(this)) >= cost, "Insufficient token allowance.");




        tokenContract.transferFrom(msg.sender, address(this), cost);

        ticketBalances[msg.sender] += quantity;

        ticketsSold += quantity;




        emit TicketPurchased(msg.sender, quantity);

    }




    function redeemTickets(uint256 quantity) external onlyOwner {

        require(quantity > 0, "Number of tickets must be greater than zero.");

        require(ticketBalances[msg.sender] >= quantity, "Insufficient tickets to redeem.");




        ticketBalances[msg.sender] -= quantity;

        ticketsSold -= quantity;

        tokenContract.transfer(msg.sender, ticketPrice * quantity);

    }




    function setTicketPrice(uint256 _ticketPrice) external onlyOwner {

        ticketPrice = _ticketPrice;

    }




    function setTotalTickets(uint256 _totalTickets) external onlyOwner {

        totalTickets = _totalTickets;

    }




    function withdrawTokens() external onlyOwner {

        uint256 balance = tokenContract.balanceOf(address(this));

        tokenContract.transfer(msg.sender, balance);

    }

}