// Import the Migrations contract
const Migrations = artifacts.require("Migrations");

module.exports = function (deployer) {
  // Use the deployer to deploy the Migrations contract
  deployer.deploy(Migrations);
};
