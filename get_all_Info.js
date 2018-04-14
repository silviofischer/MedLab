var Web3 = require('web3');

var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545")); // correct localhost?
console.log("Talking with a geth server", web3.version.api);

var address = "0x091cc7F4ACA751a6b8A4101715d6B07CD4232341"; // blockHashOrBlockNumber
var info = web3.eth.getBlock(address);
console.log(info); // output in JSON-format
