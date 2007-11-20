package org.mock4as.samples.bank
{
	import flexunit.framework.TestCase;

	public class BankSystemTest extends TestCase
	{
    	private var mockCurrencyService:MockCurrencyService;
    	private var bank:BankSystem;

		public function BankSystemTest(methodName : String){
            super(methodName);
        }
        
	    override public function setUp():void{
	        super.setUp();
	        this.mockCurrencyService = new MockCurrencyService();
	        bank = new BankSystem(mockCurrencyService);
	    }

	    override public function tearDown():void   {
	        mockCurrencyService = null;
	        bank = null;
	        super.tearDown();
	    }	
	    
		public function testTheTruth():void{
			assertTrue(true);
		}
		
	
	    public function testTransferSameCurrency()  {
		    	
	        var mockCanadianAccount:MockAccount = new MockAccount();
	        var mockCanadianAccount2:MockAccount = new MockAccount();
	
			mockCurrencyService.expects("conversionRate").withArgs(Currency.CAD, Currency.CAD).willReturn(1);
	
	        mockCanadianAccount.expects("currency").noArgs().willReturn(Currency.CAD);
	        mockCanadianAccount2.expects("currency").noArgs().willReturn(Currency.CAD);

	        mockCanadianAccount.expects("withdraw").withArg(20.0).noReturn();
	        mockCanadianAccount2.expects("deposit").withArg(20.0).noReturn();
	       
	        bank.transfer(mockCanadianAccount, mockCanadianAccount2, 20.0);
	
			mockCurrencyService.verify();
			mockCanadianAccount.verify();
			mockCanadianAccount2.verify();
	
			// verify mock behavior
			assertTrue(mockCurrencyService.errorMessage(), mockCurrencyService.success());
			// verify mock behavior
			assertTrue(mockCanadianAccount.errorMessage(), mockCanadianAccount.success());
			// verify mock behavior
			assertTrue(mockCanadianAccount2.errorMessage(), mockCanadianAccount2.success());
  	
	    }		
 	
	}
}

// Inner Class
import org.mock4as.Mock;
import org.mock4as.samples.bank.ICurrencyService;
import org.mock4as.samples.bank.Currency;

class MockCurrencyService extends Mock implements ICurrencyService {
    public function conversionRate(from:Currency, to: Currency): Number{
		record("conversionRate", from, to);
		return expectedReturnFor("conversionRate") as Number;
    	
    }		
}

import org.mock4as.samples.bank.IAccount;
import org.mock4as.samples.bank.Currency;

class MockAccount extends Mock implements IAccount {
	public function  currency():Currency{
		record("currency");
		return expectedReturnFor("currency") as Currency;
	}
	public function  balance():Number{
		record("balance");
		return expectedReturnFor("balance") as Number;
	}
	public function deposit(amount:Number){
		record("deposit", amount);
		return expectedReturnFor("deposit") as Number;
	}
	//throws InsufficientFundsException		
	public function  withdraw(amount:Number){
		record("withdraw", amount);
	}
}    