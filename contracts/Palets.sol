pragma solidity ^0.4.11;

import "zeppelin-solidity/contracts/token/MintableToken.sol";


contract Palets is MintableToken {

	string public name = "Palet";
	string public symbol = "PLT";
	uint public decimals = 18;
	uint public paletDayPrice = 3 szabo;
	uint public paletDeposit = 100 szabo;
	uint public lastRentalPaymentDate = 0;

	mapping(address => uint256) palets;
	address[] accounts; 

	function Palets() public {
		owner = msg.sender;
		lastRentalPaymentDate = now;
		// mint(owner, _amount);
	}

	function payRent(uint daysPassed) {
		if (daysPassed > 0) {
			for (uint i = 0; i < accounts.length; i++) 
			{
				address acc = accounts[i];
				uint paletCount = palets[acc];
				uint paymentAmount = paletCount.mul(daysPassed).mul(paletDayPrice).div(paletDeposit);
				if (balances[acc] > paymentAmount) {
					balances[acc] = balances[acc].sub(paymentAmount);
				}
				else {
					balances[acc] = 0;
				}
			}

			lastRentalPaymentDate = now;
		}
	}

	function simulateDayPassed() public onlyOwner {
		payRent(1);
	}

	// adds account to account list if it is new.
	modifier addAccount(address acc) {
		for (uint i = 0; i < accounts.length; i++) {
			if (accounts[i] == acc) 
				return;
		}
		accounts.push(acc);
		_;
	}

	function beginRentPalet() public payable addAccount(msg.sender)  returns(bool) {
		// require(msg.value == count.mul(paletDeposit))
		uint daysSincePayment = now - lastRentalPaymentDate;

		payRent(daysSincePayment);
		uint256 count = msg.value.div(paletDeposit);

		balances[msg.sender] = balances[msg.sender].add(count);
		palets[msg.sender] = palets[msg.sender].add(count);
	}

	function getPalets() public view returns (uint) {
		return palets[msg.sender];
	}

	function getTokens() public view returns (uint) {
		return balances[msg.sender];
	}

	function receivedPalets(address _from, uint256 _count) payable addAccount(msg.sender)  returns (bool) {
		require(_count <= palets[_from]);
		uint256 _value = _count; // TODO
	    require(_value <= balances[_from]);
	    
	   	uint daysSincePayment = now - lastRentalPaymentDate;
		payRent(daysSincePayment);

	    // SafeMath.sub will throw if there is not enough balance.
	    balances[_from] = balances[_from].sub(_value);
	    balances[msg.sender] = balances[msg.sender].add(_value);
	    Transfer(_from, msg.sender, _value);

		palets[_from] = palets[_from].sub(_count);
		palets[msg.sender] = palets[msg.sender].add(_count);

		return true;
	}

	function endRentPalet(address renter, uint256 _paletCount) onlyOwner  public returns (uint256) {
		require(_paletCount <= palets[renter]);
		
		uint daysSincePayment = now - lastRentalPaymentDate;
		payRent(daysSincePayment);

		uint value = balances[renter].mul(paletDayPrice);
		if (!msg.sender.send(value)) {
			return 0;
		}

		balances[renter] = _paletCount.mul(balances[renter]).div(palets[renter]);
		palets[renter] = palets[renter].sub(_paletCount);

		return value;
	} 
}