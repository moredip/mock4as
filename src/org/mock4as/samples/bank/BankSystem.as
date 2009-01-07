package org.mock4as.samples.bank
{
	public class BankSystem
	{
    	private var currencyService:ICurrencyService;

	    public function BankSystem(service:ICurrencyService) {
	        this.currencyService = service;
	    }

	    // thorw InsufficientFundsException 
	    public function transfer(from:IAccount, to: IAccount, amount:Number):void  {
	        var  rate:Number = this.currencyService.conversionRate(from.currency(), to.currency());
	        from.withdraw(amount);
	        to.deposit(amount * rate);
	    }		
	}
}