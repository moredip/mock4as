package org.mock4as.samples.bank
{
	public interface ICurrencyService
	{
    	function  conversionRate(from:Currency, to: Currency): Number;		
	}
}