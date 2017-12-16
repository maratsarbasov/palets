var Palets = artifacts.require("./Palets.sol");

module.exports = function(deployer) {
  deployer.deploy(Palets);
};
