package org.mock4as.samples.bank
{
	public interface IAccount
	{
    	function  currency():Currency;
    	function  balance():Number;
    	function deposit(amount:Number):Number;
    	//throws InsufficientFundsException		
    	function  withdraw(amount:Number):void; 
	}
}