package org.mock4as
{
    import flexunit.framework.TestCase;
    import flexunit.framework.TestSuite;
    
    import org.mock4as.samples.greeting.GreetingTest;
    import org.mock4as.samples.publisher.PublisherTest;
    import org.mock4as.samples.bank.BankSystemTest;
    
    public class AllTests extends TestCase
	{
	
        public function AllTests(methodName : String){
            super(methodName);
        }
            
		public static function suite():TestSuite{
	    	var myTS:TestSuite = new TestSuite();
    		myTS.addTest(new AllTests("testTheTruth"));
    		
			// test negative scenarios
    		myTS.addTest(new MockTest("testWrongMethodName"));
    		myTS.addTest(new MockTest("testWrongFirstArg"));
    		myTS.addTest(new MockTest("testWrongSecondArg"));
    		myTS.addTest(new MockTest("testWrongThirdArg"));
    		myTS.addTest(new MockTest("testWrongArgNumberLessArgs"));
    		myTS.addTest(new MockTest("testMethodInvocationMoreTimesThanExpected"));
    		myTS.addTest(new MockTest("testMethodInvocationLessTimesThanExpected"));
    		
    		myTS.addTest(new MockTest("testFailsIfMethodNeverCalled"));
  			myTS.addTest(new MockTest("testFailsIfMoreMethodsAreCalledThanExpected"));
    		// teest positive scenario
    		myTS.addTest(new MockTest("testSuccessMethodInvocation"));
    		

    		
    		// mock samples positive tests
    		myTS.addTest(new GreetingTest("testGreetingInAnyLanguage"));
    		myTS.addTest(new PublisherTest("testOneSubscriberReceivesAMessage"));
    		myTS.addTest(new BankSystemTest("testTheTruth"));
    		myTS.addTest(new BankSystemTest("testTransferSameCurrency"));
    		myTS.addTest(new BankSystemTest("testTransferDifferentCurrency"));
    		myTS.addTest(new BankSystemTest("testTransferInsufficientFunds"));
    		
    		
    		
	    	return myTS;
		}
        
		public function testTheTruth():void{
			assertTrue(true);
		} 
	}
}
	