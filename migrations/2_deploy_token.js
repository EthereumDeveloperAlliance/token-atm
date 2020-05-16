var StandardToken = artifacts.require("./StandardToken.sol");

module.exports = function (deployer) {
  deployer.deploy(StandardToken, "EthDevAlliance", "EDA", 18, 10000);
};
