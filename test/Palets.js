'use strict';

const Palets = artifacts.require('Palets.sol');

contract('Palets', function(accounts) {
    let palets;

    beforeEach(async function() {
        palets = await Palets.new();
    });

    it('simple burning', async function() {
        assert.equal(1000, await palets.getPalets());
    });
});