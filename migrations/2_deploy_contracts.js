// Import the SmartBike contract
const SmartBike = artifacts.require("SmartBike");

module.exports = function(deployer) {
  // Use the deployer to deploy the SmartBike contract
  deployer.deploy(SmartBike);
};
