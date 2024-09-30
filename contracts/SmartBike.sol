// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartBike {
    struct Bike {
        uint id;
        string qrCode;
        bool available;
    }

    mapping(uint => Bike) public bikes;

    mapping(address => uint) public rentedBikes;

    address public owner;

    event BikeRented(uint bikeId, address renter);
    event BikeReturned(uint bikeId, address renter);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier isBikeAvailable(uint bikeId) {
        require(bikes[bikeId].available == true, "Bike is not available");
        _;
    }

    function addBike(uint bikeId, string memory qrCode) public onlyOwner {
        bikes[bikeId] = Bike(bikeId, qrCode, true);
    }

    function rentBike(uint bikeId) public isBikeAvailable(bikeId) {
        bikes[bikeId].available = false;
        rentedBikes[msg.sender] = bikeId;
        emit BikeRented(bikeId, msg.sender);
    }

    function returnBike() public {
        uint bikeId = rentedBikes[msg.sender];
        require(bikeId != 0, "You don't have a rented bike");
        
        bikes[bikeId].available = true;
        rentedBikes[msg.sender] = 0;
        
        emit BikeReturned(bikeId, msg.sender);
    }
}
