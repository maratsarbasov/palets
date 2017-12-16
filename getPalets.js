// Palets.deployed().then(function(instance) { return instance.avPalets("0xa41bd3b097e5b7b9bdac6f608f82602d030c1c8b", {from: "0xa41bd3b097e5b7b9bdac6f608f82602d030c1c8b"}); }).then(function (balance) { console.log("got palets:", balance.toString(10));});



// Palets.deployed().then(function(instance) { return instance.getPalets.call({from: "0xa41bd3b097e5b7b9bdac6f608f82602d030c1c8b"}); }).then(function (balance) { console.log("got palets:", balance.toString(10));});

module.exports = function(callback) {
  Palets.deployed().then(function(instance) { return instance.getPalets.call({from: "0xa41bd3b097e5b7b9bdac6f608f82602d030c1c8b"}); })
}
